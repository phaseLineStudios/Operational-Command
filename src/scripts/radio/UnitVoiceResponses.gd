class_name UnitVoiceResponses
extends Node
## Main controller for unit voice responses.
##
## Manages both manual acknowledgments (order responses) and automatic responses
## (simulation events). Emits transmission signals for sound effect integration.

## Emitted when a unit generates a voice response.
## [param callsign] The unit's callsign.
## [param message] The full message text.
signal unit_response(callsign: String, message: String)

## Emitted when a unit starts transmitting on radio.
## [param callsign] The unit's callsign.
signal transmission_start(callsign: String)

## Emitted when a unit finishes transmitting on radio.
## [param callsign] The unit's callsign.
signal transmission_end(callsign: String)

## Path to acknowledgments data file.
const ACKNOWLEDGMENTS_PATH := "res://data/voice/unit_acknowledgments.json"

var acknowledgments: Dictionary = {}
var units_by_id: Dictionary = {}
var sim_world: SimWorld = null
var terrain_render: TerrainRender = null
var _current_transmitter: String = ""

## Reference to auto responses controller.
@onready var auto_responses: UnitAutoResponses = %AutoResponses


func _ready() -> void:
	_load_acknowledgments()

	if TTSService:
		TTSService.speaking_finished.connect(_on_tts_finished)

	if auto_responses:
		auto_responses.unit_auto_response.connect(_on_auto_response)
		auto_responses.transmission_start.connect(_on_auto_transmission_start)
		auto_responses.transmission_end_requested.connect(_on_auto_transmission_end_requested)
	else:
		push_warning("UnitVoiceResponses: UnitAutoResponses not found.")


## Load acknowledgment phrases from JSON data file.
func _load_acknowledgments() -> void:
	if not FileAccess.file_exists(ACKNOWLEDGMENTS_PATH):
		push_error("UnitVoiceResponses: Acknowledgments file not found: %s" % ACKNOWLEDGMENTS_PATH)
		return

	var file := FileAccess.open(ACKNOWLEDGMENTS_PATH, FileAccess.READ)
	if file == null:
		push_error(
			"UnitVoiceResponses: Failed to open acknowledgments file: %s" % ACKNOWLEDGMENTS_PATH
		)
		return

	var json_text := file.get_as_text()
	file.close()

	var json := JSON.new()
	var error := json.parse(json_text)
	if error != OK:
		push_error(
			(
				"UnitVoiceResponses: Failed to parse acknowledgments JSON at line %d: %s"
				% [json.get_error_line(), json.get_error_message()]
			)
		)
		return

	acknowledgments = json.data
	LogService.info(
		"Loaded %d acknowledgment categories" % acknowledgments.size(), "UnitVoiceResponses"
	)


## Initialize with references to units and simulation world.
## [param id_index] Dictionary String->ScenarioUnit (by unit id).
## [param world] Reference to SimWorld for contact data.
## [param terrain_renderer] Reference to TerrainRender for grid conversions.
## [param counter_controller] UnitCounterController for spawning counters.
## [param artillery_controller] ArtilleryController for fire mission responses.
func init(
	id_index: Dictionary,
	world: Node,
	terrain_renderer: Node = null,
	counter_controller = null,
	artillery_controller = null
) -> void:
	units_by_id = id_index
	sim_world = world
	terrain_render = terrain_renderer

	if auto_responses:
		auto_responses.init(
			world, id_index, terrain_renderer, counter_controller, artillery_controller
		)


## Handle order applied - generate acknowledgment or report.
## [param order] Order dictionary from OrdersRouter.
func _on_order_applied(order: Dictionary) -> void:
	if not TTSService or not TTSService.is_ready():
		return

	var order_type := _get_order_type_name(order.get("type", "UNKNOWN"))
	var callsign := str(order.get("callsign", "Unit"))
	var unit_id := str(order.get("unit_id", ""))

	if order_type == "REPORT":
		_handle_report(order, callsign, unit_id)
		return

	if order_type == "FIRE":
		return

	var ack := _get_acknowledgment(order_type)
	if ack.is_empty():
		return

	var response := "%s, %s" % [callsign, ack]

	_current_transmitter = callsign
	transmission_start.emit(callsign)

	TTSService.say(response)
	unit_response.emit(callsign, response)


## Get a random acknowledgment phrase for an order type.
## [param order_type] Order type string (MOVE, ATTACK, etc.).
## [return] Random acknowledgment phrase.
func _get_acknowledgment(order_type: String) -> String:
	var phrases: Array = acknowledgments.get(order_type, [])
	if phrases.is_empty():
		phrases = ["Roger.", "Copy.", "Acknowledged."]

	return phrases[randi() % phrases.size()]


## Convert order type to string name.
## [param type] Order type (int or string).
## [return] Order type name string.
func _get_order_type_name(type: Variant) -> String:
	const TYPE_NAMES := {
		0: "MOVE",
		1: "HOLD",
		2: "ATTACK",
		3: "DEFEND",
		4: "RECON",
		5: "FIRE",
		6: "REPORT",
		7: "CANCEL",
		8: "CUSTOM",
		9: "UNKNOWN"
	}

	if typeof(type) == TYPE_INT:
		return TYPE_NAMES.get(type, "UNKNOWN")
	return str(type).to_upper()


## Handle report generation based on report type.
## [param order] Order dictionary with report_type field.
## [param callsign] Unit callsign.
## [param unit_id] Unit ID.
func _handle_report(order: Dictionary, callsign: String, unit_id: String) -> void:
	var unit: ScenarioUnit = units_by_id.get(unit_id)
	if unit == null:
		LogService.warning("Unit not found: %s" % unit_id, "UnitVoiceResponses.gd:_handle_report")
		return

	var report_type := str(order.get("report_type", "status"))

	var report := ""
	match report_type:
		"status":
			report = _generate_status_report(unit, callsign)
		"position":
			report = _generate_position_report(unit, callsign)
		"contact":
			report = _generate_contact_report(unit, callsign)
		_:
			report = _generate_status_report(unit, callsign)

	if not report.is_empty():
		_current_transmitter = callsign
		transmission_start.emit(callsign)

		TTSService.say(report)
		unit_response.emit(callsign, report)

	else:
		LogService.warning("Generated empty report", "UnitVoiceResponses.gd:_handle_report")


## Generate status report: unit status, position, and current task.
## [param unit] ScenarioUnit to report on.
## [param callsign] Unit callsign.
## [return] Status report string.
func _generate_status_report(unit: ScenarioUnit, callsign: String) -> String:
	var parts: Array[String] = []

	parts.append(callsign)

	var strength_pct := 0.0
	if unit.unit and unit.unit.strength > 0:
		strength_pct = (float(unit.state_strength) / float(unit.unit.strength)) * 100.0
	var status := "nominal"
	if strength_pct <= 0:
		status = "destroyed"
	elif strength_pct < 25:
		status = "critical"
	elif strength_pct < 50:
		status = "damaged"
	elif strength_pct < 75:
		status = "light damage"
	parts.append("status %s" % status)

	var grid_pos := _get_grid_position(unit.position_m)
	if not grid_pos.is_empty():
		parts.append("position grid %s" % grid_pos)

	var task := _get_current_task(unit)
	if not task.is_empty():
		parts.append(task)

	return ". ".join(parts) + "."


## Generate position report: position, direction if moving, speed if moving.
## [param unit] ScenarioUnit to report on.
## [param callsign] Unit callsign.
## [return] Position report string.
func _generate_position_report(unit: ScenarioUnit, callsign: String) -> String:
	var parts: Array[String] = []

	parts.append(callsign)

	var grid_pos := _get_grid_position(unit.position_m)
	if not grid_pos.is_empty():
		parts.append("position grid %s" % grid_pos)
	else:
		parts.append("position unknown")

	var move_state := unit.move_state()
	if move_state == ScenarioUnit.MoveState.MOVING:
		var dest := unit.destination_m()
		if dest != Vector2.ZERO:
			var dir := _get_cardinal_direction(unit.position_m, dest)
			parts.append("moving %s" % dir)

			if unit.unit and unit.unit.speed_kph > 0:
				parts.append("speed %d kilometers per hour" % int(unit.unit.speed_kph))
	elif move_state == ScenarioUnit.MoveState.IDLE:
		parts.append("stationary")

	return ". ".join(parts) + "."


## Generate contact report: known hostile elements and their status/positions.
## [param unit] ScenarioUnit to report on.
## [param callsign] Unit callsign.
## [return] Contact report string.
func _generate_contact_report(unit: ScenarioUnit, callsign: String) -> String:
	var parts: Array[String] = []

	parts.append(callsign)

	if sim_world == null or not sim_world.has_method("get_contacts_for_unit"):
		parts.append("no contact data available")
		return ". ".join(parts) + "."

	var contacts: Array = sim_world.get_contacts_for_unit(unit.id)

	if contacts.is_empty():
		parts.append("no hostile contacts")
		return ". ".join(parts) + "."

	parts.append("%d hostile contact%s" % [contacts.size(), "s" if contacts.size() > 1 else ""])

	var max_contacts := mini(contacts.size(), 3)
	for i in max_contacts:
		var contact: ScenarioUnit = contacts[i]
		if contact == null:
			continue

		var contact_parts: Array[String] = []

		if not contact.callsign.is_empty():
			contact_parts.append(contact.callsign)
		elif contact.unit and not contact.unit.title.is_empty():
			contact_parts.append(contact.unit.title)
		else:
			contact_parts.append("hostile unit")

		var grid_pos := _get_grid_position(contact.position_m)
		if not grid_pos.is_empty():
			contact_parts.append("grid %s" % grid_pos)

		if not contact_parts.is_empty():
			parts.append(". ".join(contact_parts))

	if contacts.size() > max_contacts:
		parts.append(
			(
				"plus %d additional contact%s"
				% [
					contacts.size() - max_contacts,
					"s" if contacts.size() - max_contacts > 1 else ""
				]
			)
		)

	return ". ".join(parts) + "."


## Get grid coordinate for a position.
## [param pos_m] Position in meters.
## [return] Grid coordinate string (e.g. "123456") or empty if unavailable.
func _get_grid_position(pos_m: Vector2) -> String:
	if terrain_render:
		var grid_str := " ".join(terrain_render.pos_to_grid(pos_m).split(""))
		return grid_str
	return ""


## Get current task description for a unit.
## [param unit] ScenarioUnit to check.
## [return] Task description string or empty if none.
func _get_current_task(unit: ScenarioUnit) -> String:
	var move_state := unit.move_state()
	match move_state:
		ScenarioUnit.MoveState.MOVING:
			var dest := unit.destination_m()
			if dest != Vector2.ZERO:
				var dir := _get_cardinal_direction(unit.position_m, dest)
				return "moving %s" % dir
			return "in transit"
		ScenarioUnit.MoveState.PLANNING:
			return "planning movement"
		ScenarioUnit.MoveState.PAUSED:
			return "movement paused"
		ScenarioUnit.MoveState.BLOCKED:
			return "movement blocked"
		ScenarioUnit.MoveState.IDLE:
			return "holding position"
		_:
			return ""


## Get cardinal direction from one position to another.
## [param from] Start position.
## [param to] End position.
## [return] Cardinal direction string (e.g., "north", "northeast").
func _get_cardinal_direction(from: Vector2, to: Vector2) -> String:
	var delta := to - from
	if delta.length() < 1.0:
		return "current position"

	var angle := delta.angle()
	var degrees := rad_to_deg(angle)

	while degrees < 0:
		degrees += 360
	while degrees >= 360:
		degrees -= 360

	if degrees < 22.5 or degrees >= 337.5:
		return "east"
	elif degrees < 67.5:
		return "southeast"
	elif degrees < 112.5:
		return "south"
	elif degrees < 157.5:
		return "southwest"
	elif degrees < 202.5:
		return "west"
	elif degrees < 247.5:
		return "northwest"
	elif degrees < 292.5:
		return "north"
	else:
		return "northeast"


## Handle automatic voice response from UnitAutoResponses.
## Re-emits as a unit_response for logging/transcript.
## [param callsign] Unit callsign.
## [param message] Response message.
func _on_auto_response(callsign: String, message: String) -> void:
	unit_response.emit(callsign, message)


## Handle transmission start from auto responses.
## [param callsign] Unit callsign.
func _on_auto_transmission_start(callsign: String) -> void:
	_current_transmitter = callsign
	transmission_start.emit(callsign)


## Handle transmission end request from auto responses.
## Doesn't emit immediately - waits for TTS to finish.
## [param callsign] Unit callsign.
func _on_auto_transmission_end_requested(_callsign: String) -> void:
	# Just track who wants to end - actual emission happens when TTS finishes
	pass


## Handle TTS audio playback finished.
## Emits transmission_end for the current transmitter.
func _on_tts_finished() -> void:
	if _current_transmitter != "":
		transmission_end.emit(_current_transmitter)
		_current_transmitter = ""
