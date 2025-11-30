class_name UnitAutoResponses
extends Node
## Generates automatic unit voice responses for simulation events.

## Emitted when a unit generates an automatic voice response.
## [param callsign] The unit's callsign.
## [param message] The full message text.
signal unit_auto_response(callsign: String, message: String)

## Emitted when a unit starts transmitting on radio.
## [param callsign] The unit's callsign.
signal transmission_start(callsign: String)

## Emitted when a unit requests to end transmission (before TTS finishes).
## The parent controller will emit the actual transmission_end when TTS completes.
## [param callsign] The unit's callsign.
signal transmission_end_requested(callsign: String)

## Voice message priority levels
enum Priority { LOW = 0, NORMAL = 1, HIGH = 2, URGENT = 3 }

## Event types that trigger voice responses
enum EventType {
	MOVEMENT_STARTED,
	POSITION_REACHED,
	CONTACT_SPOTTED,
	CONTACT_LOST,
	TAKING_FIRE,
	ENGAGING_TARGET,
	AMMO_LOW,
	AMMO_CRITICAL,
	FUEL_LOW,
	FUEL_CRITICAL,
	ORDER_FAILED,
	MOVEMENT_BLOCKED,
	MISSION_CONFIRMED,
	ROUNDS_SHOT,
	ROUNDS_SPLASH,
	ROUNDS_IMPACT,
	BATTLE_DAMAGE_ASSESSMENT,
	CASUALTIES_TAKEN,
	COMMAND_CHANGE,
	STRENGTH_REPORT,
	COMBAT_INEFFECTIVE
}

## Path to auto responses data file.
const AUTO_RESPONSES_PATH := "res://data/voice/unit_auto_responses.json"

## Maximum messages in queue
@export var max_queue_size: int = 10
## Minimum time between messages from same unit (seconds)
@export var per_unit_cooldown_s: float = 3.0
## Minimum time between any voice messages (seconds)
@export var global_cooldown_s: float = 1.0

var event_config: Dictionary = {}
var order_failure_phrases: Dictionary = {}
var movement_blocked_phrases: Dictionary = {}
var commander_names: Array = []

var _sim_world: Node = null
var _units_by_id: Dictionary = {}
var _id_to_callsign: Dictionary = {}
var _terrain_render: TerrainRender = null
var _counter_controller: UnitCounterController = null
var _artillery_controller: ArtilleryController = null

var _unit_states: Dictionary = {}
var _spotted_contacts: Dictionary = {}

var _message_queue: Array[VoiceMessage] = []

var _last_message_time: float = 0.0
var _unit_last_message: Dictionary = {}
var _event_last_triggered: Dictionary = {}

var _rng := RandomNumberGenerator.new()


## Voice message in the queue
class VoiceMessage:
	var unit_id: String
	var callsign: String
	var text: String
	var priority: Priority
	var timestamp: float

	func _init(
		p_unit_id: String,
		p_callsign: String,
		p_text: String,
		p_priority: Priority,
		p_timestamp: float
	):
		unit_id = p_unit_id
		callsign = p_callsign
		text = p_text
		priority = p_priority
		timestamp = p_timestamp


func _ready() -> void:
	_rng.randomize()
	_load_auto_responses()


## Load auto response phrases from JSON data file.
func _load_auto_responses() -> void:
	if not FileAccess.file_exists(AUTO_RESPONSES_PATH):
		push_error("UnitAutoResponses: Auto responses file not found: %s" % AUTO_RESPONSES_PATH)
		return

	var file := FileAccess.open(AUTO_RESPONSES_PATH, FileAccess.READ)
	if file == null:
		push_error(
			"UnitAutoResponses: Failed to open auto responses file: %s" % AUTO_RESPONSES_PATH
		)
		return

	var json_text := file.get_as_text()
	file.close()

	var json := JSON.new()
	var error := json.parse(json_text)
	if error != OK:
		push_error(
			(
				"UnitAutoResponses: Failed to parse auto responses JSON at line %d: %s"
				% [json.get_error_line(), json.get_error_message()]
			)
		)
		return

	var data: Dictionary = json.data

	var events_json: Dictionary = data.get("events", {})
	for event_name in events_json.keys():
		var event_type := _event_name_to_enum(event_name)
		if event_type != -1:
			event_config[event_type] = events_json[event_name]

	order_failure_phrases = data.get("order_failures", {})
	movement_blocked_phrases = data.get("movement_blocked", {})
	commander_names = data.get("commander_names", [])

	LogService.info(
		(
			"Loaded %d event configs, %d order failure types, %d movement blocked types"
			% [event_config.size(), order_failure_phrases.size(), movement_blocked_phrases.size()]
		),
		"UnitAutoResponses"
	)


## Convert event name string to EventType enum value.
## [param name] Event name string (e.g., "MOVEMENT_STARTED").
## [return] EventType enum value or -1 if not found.
func _event_name_to_enum(event_name: String) -> int:
	match event_name:
		"MOVEMENT_STARTED":
			return EventType.MOVEMENT_STARTED
		"POSITION_REACHED":
			return EventType.POSITION_REACHED
		"CONTACT_SPOTTED":
			return EventType.CONTACT_SPOTTED
		"CONTACT_LOST":
			return EventType.CONTACT_LOST
		"TAKING_FIRE":
			return EventType.TAKING_FIRE
		"ENGAGING_TARGET":
			return EventType.ENGAGING_TARGET
		"AMMO_LOW":
			return EventType.AMMO_LOW
		"AMMO_CRITICAL":
			return EventType.AMMO_CRITICAL
		"FUEL_LOW":
			return EventType.FUEL_LOW
		"FUEL_CRITICAL":
			return EventType.FUEL_CRITICAL
		"ORDER_FAILED":
			return EventType.ORDER_FAILED
		"MOVEMENT_BLOCKED":
			return EventType.MOVEMENT_BLOCKED
		"MISSION_CONFIRMED":
			return EventType.MISSION_CONFIRMED
		"ROUNDS_SHOT":
			return EventType.ROUNDS_SHOT
		"ROUNDS_SPLASH":
			return EventType.ROUNDS_SPLASH
		"ROUNDS_IMPACT":
			return EventType.ROUNDS_IMPACT
		"BATTLE_DAMAGE_ASSESSMENT":
			return EventType.BATTLE_DAMAGE_ASSESSMENT
		"CASUALTIES_TAKEN":
			return EventType.CASUALTIES_TAKEN
		"COMMAND_CHANGE":
			return EventType.COMMAND_CHANGE
		"STRENGTH_REPORT":
			return EventType.STRENGTH_REPORT
		"COMBAT_INEFFECTIVE":
			return EventType.COMBAT_INEFFECTIVE
		_:
			push_warning("UnitAutoResponses: Unknown event type: %s" % event_name)
			return -1


## Initialize with simulation world reference.
## [param sim_world] SimWorld instance.
## [param units_by_id] Dictionary mapping unit_id to unit data.
## [param terrain_render] TerrainRender for position to grid conversion.
## [param counter_controller] UnitCounterController for spawning counters.
## [param artillery_controller] ArtilleryController for fire mission voice responses.
func init(
	sim_world: Node,
	units_by_id: Dictionary,
	terrain_render: TerrainRender = null,
	counter_controller: UnitCounterController = null,
	artillery_controller: ArtilleryController = null
) -> void:
	_sim_world = sim_world
	_units_by_id = units_by_id
	_terrain_render = terrain_render
	_counter_controller = counter_controller
	_artillery_controller = artillery_controller

	_build_callsign_mapping()
	_connect_unit_signals()
	_connect_artillery_signals()

	if _sim_world:
		_sim_world.unit_updated.connect(_on_unit_updated)
		_sim_world.contact_reported.connect(_on_contact_reported)
		_sim_world.engagement_reported.connect(_on_engagement_reported)

		if _sim_world._router:
			_sim_world._router.order_failed.connect(_on_order_failed)


## Build callsign mapping from units dictionary.
func _build_callsign_mapping() -> void:
	_id_to_callsign.clear()

	for unit_id in _units_by_id.keys():
		var unit = _units_by_id[unit_id]
		if unit:
			_id_to_callsign[unit_id] = unit.callsign
		else:
			_id_to_callsign[unit_id] = unit_id


## Connect to unit-specific signals (move_blocked, etc.)
func _connect_unit_signals() -> void:
	for unit_id in _units_by_id.keys():
		var unit = _units_by_id[unit_id]
		if unit and unit is ScenarioUnit:
			if not unit.move_blocked.is_connected(_on_unit_move_blocked):
				unit.move_blocked.connect(_on_unit_move_blocked.bind(unit_id))


## Connect to artillery controller signals.
func _connect_artillery_signals() -> void:
	if not _artillery_controller:
		return

	if not _artillery_controller.mission_confirmed.is_connected(_on_mission_confirmed):
		_artillery_controller.mission_confirmed.connect(_on_mission_confirmed)
	if not _artillery_controller.rounds_shot.is_connected(_on_rounds_shot):
		_artillery_controller.rounds_shot.connect(_on_rounds_shot)
	if not _artillery_controller.rounds_splash.is_connected(_on_rounds_splash):
		_artillery_controller.rounds_splash.connect(_on_rounds_splash)
	#if not _artillery_controller.rounds_impact.is_connected(_on_rounds_impact):
	#	_artillery_controller.rounds_impact.connect(_on_rounds_impact)
	if not _artillery_controller.battle_damage_assessment.is_connected(
		_on_battle_damage_assessment
	):
		_artillery_controller.battle_damage_assessment.connect(_on_battle_damage_assessment)


func _process(delta: float) -> void:
	_process_message_queue(delta)


## Process and emit queued voice messages.
func _process_message_queue(_delta: float) -> void:
	if _message_queue.is_empty():
		return

	var current_time := Time.get_ticks_msec() / 1000.0

	if current_time - _last_message_time < global_cooldown_s:
		return

	_message_queue.sort_custom(_compare_messages)
	var msg := _message_queue[0]

	var unit_last_time: float = _unit_last_message.get(msg.unit_id, 0.0)
	if current_time - unit_last_time < per_unit_cooldown_s:
		return

	_emit_voice_message(msg)
	_message_queue.remove_at(0)

	_last_message_time = current_time
	_unit_last_message[msg.unit_id] = current_time


## Compare messages for priority sorting (higher priority first).
func _compare_messages(a: VoiceMessage, b: VoiceMessage) -> bool:
	if a.priority != b.priority:
		return a.priority > b.priority
	return a.timestamp < b.timestamp


## Emit voice message via TTSService.
func _emit_voice_message(msg: VoiceMessage) -> void:
	var formatted := "%s, %s" % [msg.callsign, msg.text]

	# Emit transmission start for sound effects
	transmission_start.emit(msg.callsign)

	if TTSService:
		TTSService.say(formatted)
	unit_auto_response.emit(msg.callsign, formatted)

	# Request transmission end (actual end happens when TTS finishes)
	transmission_end_requested.emit(msg.callsign)


## Queue a voice message for a unit.
func _queue_message(unit_id: String, event_type: EventType) -> void:
	var event_key := "%s:%d" % [unit_id, event_type]
	var current_time := Time.get_ticks_msec() / 1000.0
	var last_trigger_time: float = _event_last_triggered.get(event_key, 0.0)
	var cooldown: float = event_config[event_type].get("cooldown_s", 10.0)

	if current_time - last_trigger_time < cooldown:
		return

	var callsign: String = _id_to_callsign.get(unit_id, unit_id)
	var phrases: Array = event_config[event_type].get("phrases", [])
	if phrases.is_empty():
		return
	var phrase: String = phrases[_rng.randi() % phrases.size()]

	var priority: Priority = event_config[event_type].get("priority", Priority.NORMAL)
	var msg := VoiceMessage.new(unit_id, callsign, phrase, priority, current_time)

	if _message_queue.size() >= max_queue_size:
		_message_queue.remove_at(_message_queue.size() - 1)

	_message_queue.append(msg)
	_event_last_triggered[event_key] = current_time


## Queue a message with custom text (bypasses phrase selection).
## [param unit_id] Unit ID.
## [param callsign] Unit callsign.
## [param text] Custom message text.
## [param priority] Message priority.
func _queue_custom_message(
	unit_id: String, callsign: String, text: String, priority: Priority
) -> void:
	var current_time := Time.get_ticks_msec() / 1000.0

	var msg := VoiceMessage.new(unit_id, callsign, text, priority, current_time)

	if _message_queue.size() >= max_queue_size:
		_message_queue.remove_at(_message_queue.size() - 1)

	_message_queue.append(msg)


## Handle unit state update - detect state changes.
func _on_unit_updated(unit_id: String, snapshot: Dictionary) -> void:
	var unit: ScenarioUnit = _units_by_id.get(unit_id)
	if not unit or not unit.playable:
		return

	var prev_state: Dictionary = _unit_states.get(unit_id, {})

	_check_movement_state(unit_id, prev_state, snapshot)
	_check_contact_changes(unit_id, prev_state, snapshot)
	_check_health_changes(unit_id, prev_state, snapshot)
	_unit_states[unit_id] = snapshot.duplicate()


## Check for movement state changes.
func _check_movement_state(unit_id: String, prev: Dictionary, current: Dictionary) -> void:
	var unit: ScenarioUnit = _units_by_id.get(unit_id)
	if not unit:
		return

	const IDLE = 0
	const MOVING = 2
	const ARRIVED = 5

	var prev_movement_state: int = prev.get("movement_state", IDLE)
	var curr_movement_state: int = unit.move_state()

	if prev_movement_state == IDLE and curr_movement_state == MOVING:
		_queue_message(unit_id, EventType.MOVEMENT_STARTED)

	elif prev_movement_state == MOVING and curr_movement_state == ARRIVED:
		_queue_message(unit_id, EventType.POSITION_REACHED)

	current["movement_state"] = curr_movement_state


## Check for contact changes (enemies spotted/lost).
func _check_contact_changes(unit_id: String, prev: Dictionary, current: Dictionary) -> void:
	var prev_contacts: Array = prev.get("contacts", [])
	var curr_contacts: Array = current.get("contacts", [])

	if curr_contacts.size() > prev_contacts.size():
		_queue_message(unit_id, EventType.CONTACT_SPOTTED)

	elif curr_contacts.size() < prev_contacts.size() and curr_contacts.is_empty():
		_queue_message(unit_id, EventType.CONTACT_LOST)


## Check for health/casualty changes.
func _check_health_changes(unit_id: String, prev: Dictionary, current: Dictionary) -> void:
	var unit: ScenarioUnit = _units_by_id.get(unit_id)
	if not unit or not unit.unit:
		return

	var prev_strength: int = prev.get("strength", unit.unit.strength)
	var curr_strength: int = int(unit.state_strength)
	var max_strength: int = unit.unit.strength

	current["strength"] = curr_strength

	if curr_strength >= prev_strength:
		return

	var casualties := prev_strength - curr_strength
	var strength_pct := (float(curr_strength) / float(max_strength)) * 100.0

	var prev_strength_pct := (float(prev_strength) / float(max_strength)) * 100.0
	if prev_strength_pct >= 25.0 and strength_pct < 25.0:
		_queue_message(unit_id, EventType.COMBAT_INEFFECTIVE)

	var casualty_pct := (float(casualties) / float(max_strength)) * 100.0
	if casualty_pct >= 25.0:
		_trigger_command_change(unit_id)
	else:
		_trigger_casualties(unit_id, casualties, curr_strength)


## Handle contact reported signal.
func _on_contact_reported(attacker_id: String, defender_id: String) -> void:
	var spotter: ScenarioUnit = _units_by_id.get(attacker_id)
	if spotter and spotter.playable:
		_report_contact_spotted(attacker_id, defender_id)
		_spawn_contact_counter(defender_id)


## Handle engagement reported signal.
func _on_engagement_reported(
	attacker_id: String, defender_id: String, _damage: float = 0.0
) -> void:
	var attacker: ScenarioUnit = _units_by_id.get(attacker_id)
	if attacker and attacker.playable:
		_queue_message(attacker_id, EventType.ENGAGING_TARGET)

	var defender: ScenarioUnit = _units_by_id.get(defender_id)
	if defender and defender.playable:
		_queue_message(defender_id, EventType.TAKING_FIRE)


## Handle order failure.
## [param order] Order dictionary that failed.
## [param reason] Failure reason code.
func _on_order_failed(order: Dictionary, reason: String) -> void:
	var callsign: String = order.get("callsign", "")
	if callsign == "":
		return

	var unit_id: String = ""
	for uid in _id_to_callsign.keys():
		if _id_to_callsign[uid] == callsign:
			unit_id = uid
			break

	if unit_id == "":
		return

	var default_phrases: Array = event_config[EventType.ORDER_FAILED]["phrases"]
	var phrases: Array = order_failure_phrases.get(reason, default_phrases)
	var phrase: String = phrases[_rng.randi() % phrases.size()]

	_queue_custom_message(unit_id, callsign, phrase, Priority.NORMAL)


## Handle unit move_blocked signal.
## [param reason] Block reason code from ScenarioUnit.
## [param unit_id] Unit ID (bound parameter).
func _on_unit_move_blocked(reason: String, unit_id: String) -> void:
	trigger_movement_blocked(unit_id, reason)


## Trigger ammo low event for unit.
## [param unit_id] Unit experiencing low ammo.
func trigger_ammo_low(unit_id: String) -> void:
	_queue_message(unit_id, EventType.AMMO_LOW)


## Trigger ammo critical event for unit.
## [param unit_id] Unit experiencing critical ammo.
func trigger_ammo_critical(unit_id: String) -> void:
	_queue_message(unit_id, EventType.AMMO_CRITICAL)


## Trigger fuel low event for unit.
## [param unit_id] Unit experiencing low fuel.
func trigger_fuel_low(unit_id: String) -> void:
	_queue_message(unit_id, EventType.FUEL_LOW)


## Trigger fuel critical event for unit.
## [param unit_id] Unit experiencing critical fuel.
func trigger_fuel_critical(unit_id: String) -> void:
	_queue_message(unit_id, EventType.FUEL_CRITICAL)


## Handle movement blocked event.
## [param unit_id] Unit that is blocked.
## [param reason] Block reason code.
func trigger_movement_blocked(unit_id: String, reason: String) -> void:
	var callsign: String = _id_to_callsign.get(unit_id, unit_id)

	var default_phrases: Array = event_config[EventType.MOVEMENT_BLOCKED]["phrases"]
	var phrases: Array = movement_blocked_phrases.get(reason, default_phrases)
	var phrase: String = phrases[_rng.randi() % phrases.size()]

	_queue_custom_message(unit_id, callsign, phrase, Priority.HIGH)


## Trigger casualties report.
## [param unit_id] Unit that took casualties.
## [param casualties] Number of casualties.
## [param current_strength] Current unit strength.
func _trigger_casualties(unit_id: String, casualties: int, current_strength: int) -> void:
	var callsign: String = _id_to_callsign.get(unit_id, unit_id)
	var message: String

	# Use phrase from config if casualties are minor, or strength report for moderate
	if casualties < 5:
		_queue_message(unit_id, EventType.CASUALTIES_TAKEN)
	else:
		# Report current strength
		message = "%s is %d men strong." % [callsign, current_strength]
		_queue_custom_message(unit_id, callsign, message, Priority.HIGH)


## Trigger command change announcement.
## [param unit_id] Unit experiencing command change.
func _trigger_command_change(unit_id: String) -> void:
	var callsign: String = _id_to_callsign.get(unit_id, unit_id)

	var cmd_name := "Unknown"
	if not commander_names.is_empty():
		cmd_name = commander_names[_rng.randi() % commander_names.size()]

	var message := "This is %s taking command of %s." % [cmd_name, callsign]
	_queue_custom_message(unit_id, callsign, message, Priority.URGENT)


## Generate and queue descriptive contact report.
## [param spotter_id] Unit that spotted the contact.
## [param contact_id] Enemy unit that was spotted.
func _report_contact_spotted(spotter_id: String, contact_id: String) -> void:
	var event_key := "%s:%d" % [spotter_id, EventType.CONTACT_SPOTTED]
	var current_time := Time.get_ticks_msec() / 1000.0
	var last_trigger_time: float = _event_last_triggered.get(event_key, 0.0)
	var cooldown: float = event_config[EventType.CONTACT_SPOTTED].get("cooldown_s", 15.0)

	if current_time - last_trigger_time < cooldown:
		return

	var spotter_callsign: String = _id_to_callsign.get(spotter_id, spotter_id)
	var contact_unit = _units_by_id.get(contact_id)
	if not contact_unit:
		_queue_message(spotter_id, EventType.CONTACT_SPOTTED)
		return

	var description := _get_unit_description(contact_unit)
	var grid_pos := _get_grid_from_position(contact_unit.position_m)

	var message := "Contact! %s at grid %s." % [description, grid_pos]
	var priority: Priority = event_config[EventType.CONTACT_SPOTTED].get("priority", Priority.HIGH)
	var msg := VoiceMessage.new(spotter_id, spotter_callsign, message, priority, current_time)

	if _message_queue.size() >= max_queue_size:
		_message_queue.remove_at(_message_queue.size() - 1)

	_message_queue.append(msg)
	_event_last_triggered[event_key] = current_time


## Get descriptive text for a unit (e.g., "Enemy infantry platoon").
## [param unit] Unit data.
## [return] Description string.
func _get_unit_description(unit: ScenarioUnit) -> String:
	var affiliation := "Enemy"
	if unit:
		match unit.affiliation:
			0:
				affiliation = "Friendly"
			1:
				affiliation = "Enemy"
			_:
				affiliation = "Unknown"

	var unit_type := "forces"
	if unit and unit.unit.type != -1:
		unit_type = MilSymbol.UnitType.keys()[unit.unit.type]
	elif unit and unit.unit.title != "":
		unit_type = unit.unit.title.to_lower().split(" ")[0]

	var size_str := ""
	if unit:
		match unit.unit.size:
			0:
				size_str = "team"
			1:
				size_str = "squad"
			2:
				size_str = "platoon"
			3:
				size_str = "company"
			4:
				size_str = "battalion"

	if size_str != "":
		return "%s %s %s" % [affiliation, unit_type, size_str]
	else:
		return "%s %s" % [affiliation, unit_type]


## Get grid coordinate from terrain position.
## [param pos_m] Position in terrain meters.
## [return] Grid string (e.g., "A5").
func _get_grid_from_position(pos_m: Vector2) -> String:
	if not _terrain_render:
		return "unknown"

	return _terrain_render.pos_to_grid(pos_m)


## Spawn a unit counter for a spotted contact.
## [param contact_id] Enemy unit ID to spawn counter for.
func _spawn_contact_counter(contact_id: String) -> void:
	if _spotted_contacts.get(contact_id, false):
		return

	if not _counter_controller:
		return

	var contact_unit: ScenarioUnit = _units_by_id.get(contact_id)
	if not contact_unit:
		return

	var affiliation := MilSymbol.UnitAffiliation.ENEMY
	if contact_unit:
		affiliation = _parse_unit_affiliation(contact_unit.affiliation)

	var unit_type := MilSymbol.UnitType.INFANTRY
	if contact_unit:
		unit_type = contact_unit.unit.type

	var unit_size := MilSymbol.UnitSize.PLATOON
	if contact_unit:
		unit_size = contact_unit.unit.size

	var callsign: String = contact_unit.callsign
	var pos_m: Vector2 = contact_unit.position_m

	_counter_controller.spawn_counter_at_position(
		affiliation, unit_type, unit_size, callsign, pos_m
	)

	_spotted_contacts[contact_id] = true

	LogService.debug(
		"Spawned counter for contact %s at %s" % [callsign, pos_m], "UnitAutoResponses.gd"
	)


## parses [enum ScenarioUnit.Affiliation] to [enum MilSymbol.UnitAffiliation].
## [param aff] [enum ScenarioUnit.Affiliation] to parse.
## [return] parsed [enum MilSymbol.UnitAffiliation].
func _parse_unit_affiliation(aff: ScenarioUnit.Affiliation) -> MilSymbol.UnitAffiliation:
	match aff:
		0:
			return MilSymbol.UnitAffiliation.FRIEND
		1:
			return MilSymbol.UnitAffiliation.ENEMY
		_:
			return MilSymbol.UnitAffiliation.UNKNOWN


## Handle artillery mission confirmation.
## [param unit_id] Artillery unit ID.
## [param _target_pos] Target position in terrain meters.
## [param _ammo_type] Ammunition type (e.g., "MORTAR_AP").
## [param _rounds] Number of rounds.
func _on_mission_confirmed(
	unit_id: String, _target_pos: Vector2, _ammo_type: String, _rounds: int
) -> void:
	var unit: ScenarioUnit = _units_by_id.get(unit_id)
	if not unit or not unit.playable:
		return
	_queue_message(unit_id, EventType.MISSION_CONFIRMED)


## Handle rounds shot ("Shot" call).
## [param unit_id] Artillery unit ID.
## [param _target_pos] Target position in terrain meters.
## [param _ammo_type] Ammunition type.
## [param _rounds] Number of rounds.
func _on_rounds_shot(
	unit_id: String, _target_pos: Vector2, _ammo_type: String, _rounds: int
) -> void:
	var unit: ScenarioUnit = _units_by_id.get(unit_id)
	if not unit or not unit.playable:
		return
	_queue_message(unit_id, EventType.ROUNDS_SHOT)


## Handle rounds splash warning (5s before impact).
## [param unit_id] Artillery unit ID.
## [param _target_pos] Target position in terrain meters.
## [param _ammo_type] Ammunition type.
## [param _rounds] Number of rounds.
func _on_rounds_splash(
	unit_id: String, _target_pos: Vector2, _ammo_type: String, _rounds: int
) -> void:
	var unit: ScenarioUnit = _units_by_id.get(unit_id)
	if not unit or not unit.playable:
		return
	_queue_message(unit_id, EventType.ROUNDS_SPLASH)


## Handle rounds impact.
## [param unit_id] Artillery unit ID.
## [param _target_pos] Target position in terrain meters.
## [param _ammo_type] Ammunition type.
## [param _rounds] Number of rounds.
## [param _damage] Total damage dealt.
func _on_rounds_impact(
	unit_id: String, _target_pos: Vector2, _ammo_type: String, _rounds: int, _damage: float
) -> void:
	var unit: ScenarioUnit = _units_by_id.get(unit_id)
	if not unit or not unit.playable:
		return
	_queue_message(unit_id, EventType.ROUNDS_IMPACT)


## Handle battle damage assessment from observer.
## [param observer_id] Observer unit ID.
## [param target_pos] Impact position in terrain meters.
## [param description] BDA description text.
func _on_battle_damage_assessment(
	observer_id: String, target_pos: Vector2, description: String
) -> void:
	var observer: ScenarioUnit = _units_by_id.get(observer_id)
	if not observer or not observer.playable:
		return

	var observer_callsign: String = _id_to_callsign.get(observer_id, observer_id)
	var grid_pos := " ".join(_get_grid_from_position(target_pos).split(""))
	var message := "%s At grid %s." % [description, grid_pos]

	_queue_custom_message(observer_id, observer_callsign, message, Priority.HIGH)
