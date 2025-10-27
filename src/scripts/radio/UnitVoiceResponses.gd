class_name UnitVoiceResponses
extends Node
## Generates unit voice acknowledgments for orders.
## Connects to OrdersRouter signals and triggers TTS responses.

## Acknowledgment phrases by order type.
const ACKNOWLEDGMENTS := {
	"MOVE":
	[
		"Moving out.",
		"Roger, moving.",
		"On the way.",
		"Wilco, moving to position.",
		"Acknowledged, moving."
	],
	"HOLD":
	[
		"Holding position.",
		"Roger, holding.",
		"Holding here.",
		"Copy, holding position.",
		"Acknowledged, holding."
	],
	"CANCEL":
	[
		"Roger, canceling order.",
		"Acknowledged, standing by.",
		"Copy, canceling.",
		"Order canceled."
	],
	"ATTACK":
	[
		"Engaging target.",
		"Roger, engaging.",
		"Attack confirmed.",
		"Wilco, engaging hostile.",
		"Copy, attacking."
	],
	"DEFEND":
	[
		"Roger, going defensive.",
		"Copy, defensive position.",
		"Acknowledged, defending.",
		"Going defensive."
	],
	"RECON":
	[
		"Roger, moving to observe.",
		"Copy, recon mission.",
		"Acknowledged, reconnoitering.",
		"Moving to recon position."
	],
	"FIRE":
	[
		"Fire mission acknowledged.",
		"Roger, firing.",
		"Copy, engaging target.",
		"Fire mission, wilco."
	],
	"REPORT": ["Roger, sending report.", "Copy, reporting.", "Acknowledged."],
	"CUSTOM": ["Roger.", "Acknowledged.", "Copy."]
}

## Reference to TTS service (autoload).
var tts_service = null
## Reference to unit index (unit_id -> ScenarioUnit).
var units_by_id: Dictionary = {}
## Reference to SimWorld for contact data.
var sim_world: SimWorld = null
## Reference to terrain renderer for grid conversions.
var terrain_render: TerrainRender = null


func _ready() -> void:
	# Reference the TTS autoload
	tts_service = get_node_or_null("/root/TTSService")
	if not tts_service:
		push_warning("UnitVoiceResponses: TTSService autoload not found.")


## Initialize with references to units and simulation world.
## [param id_index] Dictionary String->ScenarioUnit (by unit id).
## [param world] Reference to SimWorld for contact data.
## [param terrain_renderer] Reference to TerrainRender for grid conversions.
func init(id_index: Dictionary, world: Node, terrain_renderer: Node = null) -> void:
	units_by_id = id_index
	sim_world = world
	terrain_render = terrain_renderer


## Handle order applied - generate acknowledgment or report.
## [param order] Order dictionary from OrdersRouter.
func _on_order_applied(order: Dictionary) -> void:
	if not tts_service or not tts_service.is_ready():
		return

	var order_type := _get_order_type_name(order.get("type", "UNKNOWN"))
	var callsign := str(order.get("callsign", "Unit"))
	var unit_id := str(order.get("unit_id", ""))

	# Handle REPORT orders specially
	if order_type == "REPORT":
		_handle_report(order, callsign, unit_id)
		return

	# Get random acknowledgment for this order type
	var ack := _get_acknowledgment(order_type)
	if ack.is_empty():
		return

	# Format: "Callsign, acknowledgment"
	# Example: "Alpha, moving out."
	var response := "%s, %s" % [callsign, ack]

	# Speak the response
	tts_service.say(response)


## Get a random acknowledgment phrase for an order type.
## [param order_type] Order type string (MOVE, ATTACK, etc.).
## [return] Random acknowledgment phrase.
func _get_acknowledgment(order_type: String) -> String:
	var phrases: Array = ACKNOWLEDGMENTS.get(order_type, [])
	if phrases.is_empty():
		phrases = ["Roger.", "Copy.", "Acknowledged."]

	return phrases[randi() % phrases.size()]


## Convert order type to string name.
## [param type] Order type (int or string).
## [return] Order type name string.
func _get_order_type_name(type: Variant) -> String:
	# Map OrdersParser.OrderType enum indices to string tokens
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
		tts_service.say(report)
	else:
		LogService.warning("Generated empty report", "UnitVoiceResponses.gd:_handle_report")


## Generate status report: unit status, position, and current task.
## [param unit] ScenarioUnit to report on.
## [param callsign] Unit callsign.
## [return] Status report string.
func _generate_status_report(unit: ScenarioUnit, callsign: String) -> String:
	var parts: Array[String] = []

	# Callsign
	parts.append(callsign)

	# Status (health/strength)
	var strength_pct := 0.0
	if unit.unit and unit.unit.strength > 0:
		strength_pct = (float(unit.unit.state_strength) / float(unit.unit.strength)) * 100.0
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

	# Position (grid coordinate)
	var grid_pos := _get_grid_position(unit.position_m)
	if not grid_pos.is_empty():
		parts.append("position grid %s" % grid_pos)

	# Current task
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

	# Callsign
	parts.append(callsign)

	# Position (grid coordinate)
	var grid_pos := _get_grid_position(unit.position_m)
	if not grid_pos.is_empty():
		parts.append("position grid %s" % grid_pos)
	else:
		parts.append("position unknown")

	# Movement state
	var move_state := unit.move_state()
	if move_state == ScenarioUnit.MoveState.MOVING:
		# Get direction to destination
		var dest := unit.destination_m()
		if dest != Vector2.ZERO:
			var dir := _get_cardinal_direction(unit.position_m, dest)
			parts.append("moving %s" % dir)

			# Speed
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

	# Callsign
	parts.append(callsign)

	# Get contacts from SimWorld
	if sim_world == null or not sim_world.has_method("get_contacts_for_unit"):
		parts.append("no contact data available")
		return ". ".join(parts) + "."

	var contacts: Array = sim_world.get_contacts_for_unit(unit.id)

	if contacts.is_empty():
		parts.append("no hostile contacts")
		return ". ".join(parts) + "."

	# Report contacts
	parts.append("%d hostile contact%s" % [contacts.size(), "s" if contacts.size() > 1 else ""])

	# Report details for each contact (limit to 3 for brevity)
	var max_contacts := mini(contacts.size(), 3)
	for i in max_contacts:
		var contact: ScenarioUnit = contacts[i]
		if contact == null:
			continue

		var contact_parts: Array[String] = []

		# Callsign or type
		if not contact.callsign.is_empty():
			contact_parts.append(contact.callsign)
		elif contact.unit and not contact.unit.title.is_empty():
			contact_parts.append(contact.unit.title)
		else:
			contact_parts.append("hostile unit")

		# Position
		var grid_pos := _get_grid_position(contact.position_m)
		if not grid_pos.is_empty():
			contact_parts.append("grid %s" % grid_pos)

		if not contact_parts.is_empty():
			parts.append(". ".join(contact_parts))

	if contacts.size() > max_contacts:
		parts.append("plus %d additional contact%s" % [
			contacts.size() - max_contacts,
			"s" if contacts.size() - max_contacts > 1 else ""
		])

	return ". ".join(parts) + "."


## Get grid coordinate for a position.
## [param pos_m] Position in meters.
## [return] Grid coordinate string (e.g. "123456") or empty if unavailable.
func _get_grid_position(pos_m: Vector2) -> String:
	if terrain_render:
		var grid_str: = " ".join(terrain_render.pos_to_grid(pos_m).split(""))
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

	# Normalize to 0-360
	while degrees < 0:
		degrees += 360
	while degrees >= 360:
		degrees -= 360

	# Map to cardinal/intercardinal directions
	# 0° is east, 90° is south, 180° is west, 270° is north
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
