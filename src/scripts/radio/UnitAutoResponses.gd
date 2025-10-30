class_name UnitAutoResponses
extends Node
## Generates automatic unit voice responses for simulation events.
##
## Monitors unit state changes and generates contextual voice reports like:
## - "Contact spotted!" when enemy units detected
## - "Position reached" when arriving at destination
## - "Taking fire!" when under attack
## - etc.

## Voice message priority levels
enum Priority {
	LOW = 0,      ## Info, routine updates
	NORMAL = 1,   ## Movement, positions
	HIGH = 2,     ## Contacts, objectives
	URGENT = 3    ## Combat, casualties
}

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
	MOVEMENT_BLOCKED
}

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


## Event configuration - defines phrases and cooldowns for each event type
const EVENT_CONFIG := {
	EventType.MOVEMENT_STARTED: {
		"phrases": [
			"Moving out.",
			"On the move.",
			"Proceeding to waypoint.",
			"Roger, moving."
		],
		"priority": Priority.NORMAL,
		"cooldown_s": 10.0
	},
	EventType.POSITION_REACHED: {
		"phrases": [
			"Position reached.",
			"In position.",
			"Arrived at waypoint.",
			"We're here."
		],
		"priority": Priority.NORMAL,
		"cooldown_s": 5.0
	},
	EventType.CONTACT_SPOTTED: {
		"phrases": [
			"Contact!",
			"Enemy spotted!",
			"Eyes on hostile forces!",
			"We have contact!"
		],
		"priority": Priority.HIGH,
		"cooldown_s": 15.0
	},
	EventType.CONTACT_LOST: {
		"phrases": [
			"Contact lost.",
			"Lost visual.",
			"Target out of sight."
		],
		"priority": Priority.LOW,
		"cooldown_s": 20.0
	},
	EventType.TAKING_FIRE: {
		"phrases": [
			"Taking fire!",
			"We're under fire!",
			"Incoming fire!",
			"Contact, contact!"
		],
		"priority": Priority.URGENT,
		"cooldown_s": 20.0
	},
	EventType.ENGAGING_TARGET: {
		"phrases": [
			"Engaging!",
			"Firing!",
			"Engaging hostile forces!",
			"Opening fire!"
		],
		"priority": Priority.HIGH,
		"cooldown_s": 15.0
	},
	EventType.AMMO_LOW: {
		"phrases": [
			"Running low on ammo.",
			"Ammo running low.",
			"We're low on ammunition."
		],
		"priority": Priority.HIGH,
		"cooldown_s": 60.0
	},
	EventType.AMMO_CRITICAL: {
		"phrases": [
			"Critically low on ammo!",
			"Almost out of ammunition!",
			"We need resupply!"
		],
		"priority": Priority.URGENT,
		"cooldown_s": 60.0
	},
	EventType.FUEL_LOW: {
		"phrases": [
			"Fuel running low.",
			"Low on fuel.",
			"We need to refuel soon."
		],
		"priority": Priority.HIGH,
		"cooldown_s": 60.0
	},
	EventType.FUEL_CRITICAL: {
		"phrases": [
			"Fuel critical!",
			"Almost out of fuel!",
			"We're running on fumes!"
		],
		"priority": Priority.URGENT,
		"cooldown_s": 60.0
	},
	EventType.ORDER_FAILED: {
		"phrases": [
			"Unable to comply.",
			"Negative.",
			"Can't execute that order."
		],
		"priority": Priority.NORMAL,
		"cooldown_s": 5.0
	},
	EventType.MOVEMENT_BLOCKED: {
		"phrases": [
			"We're blocked!",
			"Can't proceed!",
			"Movement blocked!"
		],
		"priority": Priority.HIGH,
		"cooldown_s": 10.0
	}
}

## Mapping of order failure reasons to specific response phrases
const ORDER_FAILURE_PHRASES := {
	"unknown_unit": [
		"Unable to comply, unit not found.",
		"Negative, unknown unit.",
		"Can't locate that unit."
	],
	"dead_unit": [
		"Unable to comply, unit is down.",
		"Negative, that unit is out of action.",
		"Unit is no longer operational."
	],
	"unsupported_type": [
		"Unable to comply, invalid order type.",
		"Negative, can't execute that order.",
		"Order not recognized."
	],
	"move_missing_destination": [
		"Unable to comply, no destination specified.",
		"Negative, where do you want us to go?",
		"Need a destination."
	],
	"move_destination_zero": [
		"Unable to comply, invalid destination.",
		"Negative, can't move there.",
		"That's not a valid location."
	],
	"move_plan_failed": [
		"Unable to comply, can't find a route.",
		"Negative, no path available.",
		"Can't get there from here."
	],
	"recon_no_destination": [
		"Unable to comply, need a recon target.",
		"Negative, where should we recon?",
		"Need a location to scout."
	],
	"fire_missing_target": [
		"Unable to comply, no target.",
		"Negative, who do we engage?",
		"Need a target."
	],
	"fire_unhandled": [
		"Unable to comply, can't engage.",
		"Negative, unable to fire.",
		"Can't execute fire mission."
	]
}

## Mapping of movement blocked reasons to specific response phrases
const MOVEMENT_BLOCKED_PHRASES := {
	"no_path": [
		"Can't find a route!",
		"No path available!",
		"Unable to reach destination!"
	],
	"blocked_cell": [
		"We're stuck!",
		"Terrain is impassable!",
		"Can't move through here!"
	],
	"no_grid": [
		"Navigation error!",
		"Can't navigate!",
		"System error!"
	],
	"no_unit": [
		"Unit error!",
		"Can't move!",
		"System error!"
	],
	"no_speed": [
		"We're immobilized!",
		"Can't move, immobilized!",
		"Movement systems down!"
	]
}

## Maximum messages in queue
@export var max_queue_size: int = 10
## Minimum time between messages from same unit (seconds)
@export var per_unit_cooldown_s: float = 3.0
## Minimum time between any voice messages (seconds)
@export var global_cooldown_s: float = 1.0

var _sim_world: Node = null
var _units_by_id: Dictionary = {}
var _id_to_callsign: Dictionary = {}
var _terrain_render: TerrainRender = null
var _counter_controller: UnitCounterController = null

var _unit_states: Dictionary = {}
var _spotted_contacts: Dictionary = {}

var _message_queue: Array[VoiceMessage] = []

var _last_message_time: float = 0.0
var _unit_last_message: Dictionary = {}
var _event_last_triggered: Dictionary = {}

var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()


## Initialize with simulation world reference.
## [param sim_world] SimWorld instance.
## [param units_by_id] Dictionary mapping unit_id to unit data.
## [param terrain_render] TerrainRender for position to grid conversion.
## [param counter_controller] UnitCounterController for spawning counters.
func init(
	sim_world: Node,
	units_by_id: Dictionary,
	terrain_render: TerrainRender = null,
	counter_controller: UnitCounterController = null
) -> void:
	_sim_world = sim_world
	_units_by_id = units_by_id
	_terrain_render = terrain_render
	_counter_controller = counter_controller

	_build_callsign_mapping()
	_connect_unit_signals()

	if _sim_world:
		_sim_world.unit_updated.connect(_on_unit_updated)
		_sim_world.contact_reported.connect(_on_contact_reported)
		_sim_world.engagement_reported.connect(_on_engagement_reported)

		if _sim_world._router:
			_sim_world._router.order_failed.connect(_on_order_failed)

	LogService.info(
		"UnitAutoResponses initialized with %d units" % _id_to_callsign.size(),
		"UnitAutoResponses.gd"
	)


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
			# Connect to move_blocked signal
			if not unit.move_blocked.is_connected(_on_unit_move_blocked):
				unit.move_blocked.connect(_on_unit_move_blocked.bind(unit_id))


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
	if TTSService:
		TTSService.say(formatted)
	LogService.debug("Unit voice: %s" % formatted, "UnitAutoResponses.gd")


## Queue a voice message for a unit.
func _queue_message(unit_id: String, event_type: EventType) -> void:
	var event_key := "%s:%d" % [unit_id, event_type]
	var current_time := Time.get_ticks_msec() / 1000.0
	var last_trigger_time: float = _event_last_triggered.get(event_key, 0.0)
	var cooldown: float = EVENT_CONFIG[event_type].get("cooldown_s", 10.0)

	if current_time - last_trigger_time < cooldown:
		return

	var callsign: String = _id_to_callsign.get(unit_id, unit_id)
	var phrases: Array = EVENT_CONFIG[event_type].get("phrases", [])
	if phrases.is_empty():
		return
	var phrase: String = phrases[_rng.randi() % phrases.size()]

	var priority: Priority = EVENT_CONFIG[event_type].get("priority", Priority.NORMAL)
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
	var prev_state: Dictionary = _unit_states.get(unit_id, {})

	_check_movement_state(unit_id, prev_state, snapshot)
	_check_contact_changes(unit_id, prev_state, snapshot)
	_unit_states[unit_id] = snapshot.duplicate()


## Check for movement state changes.
func _check_movement_state(unit_id: String, prev: Dictionary, current: Dictionary) -> void:
	var prev_movement_state: String = prev.get("movement_state", "IDLE")
	var curr_movement_state: String = current.get("movement_state", "IDLE")

	if prev_movement_state == "IDLE" and curr_movement_state == "MOVING":
		_queue_message(unit_id, EventType.MOVEMENT_STARTED)

	elif prev_movement_state == "MOVING" and curr_movement_state == "ARRIVED":
		_queue_message(unit_id, EventType.POSITION_REACHED)


## Check for contact changes (enemies spotted/lost).
func _check_contact_changes(unit_id: String, prev: Dictionary, current: Dictionary) -> void:
	var prev_contacts: Array = prev.get("contacts", [])
	var curr_contacts: Array = current.get("contacts", [])

	if curr_contacts.size() > prev_contacts.size():
		_queue_message(unit_id, EventType.CONTACT_SPOTTED)

	elif curr_contacts.size() < prev_contacts.size() and curr_contacts.is_empty():
		_queue_message(unit_id, EventType.CONTACT_LOST)


## Handle contact reported signal.
func _on_contact_reported(attacker_id: String, defender_id: String) -> void:
	_report_contact_spotted(attacker_id, defender_id)

	_spawn_contact_counter(defender_id)


## Handle engagement reported signal.
func _on_engagement_reported(attacker_id: String, defender_id: String) -> void:
	_queue_message(attacker_id, EventType.ENGAGING_TARGET)
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

	var default_phrases: Array = EVENT_CONFIG[EventType.ORDER_FAILED]["phrases"]
	var phrases: Array = ORDER_FAILURE_PHRASES.get(reason, default_phrases)
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

	# Get specific phrase for this block reason
	var default_phrases: Array = EVENT_CONFIG[EventType.MOVEMENT_BLOCKED]["phrases"]
	var phrases: Array = MOVEMENT_BLOCKED_PHRASES.get(reason, default_phrases)
	var phrase: String = phrases[_rng.randi() % phrases.size()]

	# Queue message with specific phrase
	_queue_custom_message(unit_id, callsign, phrase, Priority.HIGH)


## Generate and queue descriptive contact report.
## [param spotter_id] Unit that spotted the contact.
## [param contact_id] Enemy unit that was spotted.
func _report_contact_spotted(spotter_id: String, contact_id: String) -> void:
	var event_key := "%s:%d" % [spotter_id, EventType.CONTACT_SPOTTED]
	var current_time := Time.get_ticks_msec() / 1000.0
	var last_trigger_time: float = _event_last_triggered.get(event_key, 0.0)
	var cooldown: float = EVENT_CONFIG[EventType.CONTACT_SPOTTED].get("cooldown_s", 15.0)

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
	var priority: Priority = EVENT_CONFIG[EventType.CONTACT_SPOTTED].get("priority", Priority.HIGH)
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
			0: affiliation = "Friendly"
			1: affiliation = "Enemy"
			_: affiliation = "Unknown"

	var unit_type := "forces"
	if unit and unit.unit.type != -1:
		unit_type = MilSymbol.UnitType.keys()[unit.unit.type]
	elif unit and unit.unit.title != "":
		unit_type = unit.unit.title.to_lower().split(" ")[0]

	var size_str := ""
	if unit:
		match unit.unit.size:
			0: size_str = "team"
			1: size_str = "squad"
			2: size_str = "platoon"
			3: size_str = "company"
			4: size_str = "battalion"

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

	_counter_controller.spawn_counter_at_position(affiliation, unit_type, unit_size, callsign, pos_m)

	_spotted_contacts[contact_id] = true

	LogService.debug(
		"Spawned counter for contact %s at %s" % [callsign, pos_m],
		"UnitAutoResponses.gd"
	)


## parses [enum ScenarioUnit.Affiliation] to [enum MilSymbol.UnitAffiliation].
## [param aff] [enum ScenarioUnit.Affiliation] to parse.
## [return] parsed [enum MilSymbol.UnitAffiliation].
func _parse_unit_affiliation(aff: ScenarioUnit.Affiliation) -> MilSymbol.UnitAffiliation:
	match (aff):
		0: return MilSymbol.UnitAffiliation.FRIEND
		1: return MilSymbol.UnitAffiliation.ENEMY
		_: return MilSymbol.UnitAffiliation.UNKNOWN
