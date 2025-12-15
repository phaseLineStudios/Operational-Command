class_name SimWorld
extends Node
## Authoritative deterministic simulation loop.
##
## Runs a fixed-step mission sim (INIT->RUNNING->PAUSED->COMPLETED):
## process_orders -> update_movement -> update_los -> resolve_combat ->
## update_morale -> emit_events -> record_replay. Provides read-only queries
## and emits events via signals for UI/logging.
## @experimental

## Emitted when a unit snapshot changes.
signal unit_updated(unit_id: String, snapshot: Dictionary)
## Emitted when LOS contact is reported (attacker->defender).
signal contact_reported(attacker_id: String, defender_id: String)
## Emitted for radio/log feedback.
## Levels: "debug" (internal), "info" (radio), "warn" (status), "error" (critical)
## Only non-debug messages should appear in radio transcript.
## [param unit] Optional unit callsign/ID of the speaker (empty string if not specified).
signal radio_message(level: String, text: String, unit: String)
## Emitted when mission state transitions.
signal mission_state_changed(prev: State, next: State)
## Emitted when damage > 0 is applied this tick (attacker->defender).
signal engagement_reported(attacker_id: String, defender_id: String, damage: float)

## Simulation state machine.
enum State { INIT, RUNNING, PAUSED, COMPLETED }

## Fixed tick rate (Hz).
@export var tick_hz := 5.0
## Initial RNG seed (0 -> randomize)
@export var rng_seed: int = 0
## LOS helper/adapter.
@export var los_adapter: LOSAdapter
## Movement adapter.
@export var movement_adapter: MovementAdapter
## Combat controller.
@export var combat_controller: CombatController
## Combat adapter.
@export var combat_adapter: CombatAdapter
## Combat controller.
@export var trigger_engine: TriggerEngine
## Orders router.
@export var _router: OrdersRouter
## Ammo system node.
@export var ammo_system: AmmoSystem
## Fuel system node.
@export var fuel_system: FuelSystem
## Artillery controller for indirect fire missions.
@export var artillery_controller: ArtilleryController
## Engineer controller for engineer tasks (mines, demo, bridges).
@export var engineer_controller: EngineerController
## Environment controller for environment laoding
@export var environment_controller: EnvironmentController
## Grace period before ending (seconds) to avoid flapping.
@export var auto_end_grace_s := 2.0

var _state: State = State.INIT
var _dt_accum := 0.0
var _tick_dt := 0.2
var _time_scale := 1.0
var _tick_idx := 0
var _rng := RandomNumberGenerator.new()
var _orders: OrdersQueue = OrdersQueue.new()
var _scenario: ScenarioData
var _units_by_id: Dictionary = {}
var _units_by_callsign: Dictionary = {}
var _playable_by_callsign: Dictionary = {}
var _friendlies: Array[ScenarioUnit] = []
var _enemies: Array[ScenarioUnit] = []
var _replay: Array[Dictionary] = []
var _last_contacts: PackedStringArray = []
var _contact_pairs: Array = []
var _mission_complete_accum := 0.0
var _unit_positions: Dictionary = {}
var _contact_key_cache: Dictionary = {}


## Initializes tick timing/RNG and wires router signals. Starts processing.
func _ready() -> void:
	_tick_dt = 1.0 / max(tick_hz, 0.001)
	if rng_seed == 0:
		_rng.randomize()
	else:
		_rng.seed = rng_seed

	_router.order_applied.connect(_on_order_applied)
	_router.order_failed.connect(_on_order_failed)

	# Note: Ammo/fuel warnings are handled by UnitAutoResponses via HQTable signal connections.
	# SimWorld no longer emits radio_message for these to avoid duplicate transmissions.

	if engineer_controller:
		engineer_controller.task_confirmed.connect(
			func(uid, task, _pos):
				var su: ScenarioUnit = _units_by_id.get(uid)
				var callsign: String = su.callsign if su else uid
				emit_signal(
					"radio_message", "info", "%s: roger, %s task acknowledged." % [callsign, task]
				)
		)
		engineer_controller.task_started.connect(
			func(uid, task, _pos):
				var su: ScenarioUnit = _units_by_id.get(uid)
				var callsign: String = su.callsign if su else uid
				emit_signal("radio_message", "info", "%s: starting %s work." % [callsign, task])
		)
		engineer_controller.task_completed.connect(
			func(uid, task, _pos):
				var su: ScenarioUnit = _units_by_id.get(uid)
				var callsign: String = su.callsign if su else uid
				emit_signal("radio_message", "info", "%s: %s task complete." % [callsign, task])
		)

	set_process(true)


## Initialize world from a scenario and build unit indices.
## [param scenario] ScenarioData to load.
func init_world(scenario: ScenarioData) -> void:
	_scenario = scenario
	_units_by_id.clear()
	_units_by_callsign.clear()
	_friendlies.clear()
	_enemies.clear()
	_unit_positions.clear()

	var all: Array = []
	all.append_array(scenario.units)
	all.append_array(scenario.playable_units)

	for su: ScenarioUnit in all:
		if su == null:
			continue
		_units_by_id[su.id] = su
		if su.callsign != "":
			_units_by_callsign[su.callsign] = su.id
		if su.affiliation == ScenarioUnit.Affiliation.FRIEND:
			_friendlies.append(su)
		else:
			_enemies.append(su)
		if su.playable:
			_playable_by_callsign[su.callsign] = su.id
	_router.bind_units(_units_by_id, _units_by_callsign)
	if environment_controller:
		environment_controller.scenario = scenario
	if artillery_controller:
		_router.artillery_controller = artillery_controller
	_register_logistics_units()

	# Initialize custom commands for this mission
	_init_custom_commands(scenario)


## Initialize mission resolution and connect state changes.
## [param primary_ids] Objective IDs.
## [param scenario] Scenario to initialize.
func init_resolution(objs: Array[ScenarioObjectiveData]) -> void:
	var primary_ids: Array[String] = []
	for obj in objs:
		primary_ids.append(obj.id)
	Game.start_scenario(primary_ids)
	if not mission_state_changed.is_connected(_on_state_change_for_resolution):
		mission_state_changed.connect(_on_state_change_for_resolution)
	if Game.resolution.objective_updated.is_connected(_on_objective_updated):
		Game.resolution.objective_updated.connect(_on_objective_updated)


## Immidiatly check if mission is completed on objective state change.
## [param _id] Id of updated objective.
## [param _obj_state] New state of objective.
func _on_objective_updated(_id: String, _obj_state: int) -> void:
	_mission_complete_check(0.0)


## Fixed-rate loop; advances the sim in discrete ticks while RUNNING.
## [param dt] Frame delta seconds.
func _process(dt: float) -> void:
	if _state != State.RUNNING:
		if _state == State.PAUSED:
			_process_orders()
			trigger_engine.tick(dt)
		return
	_dt_accum += dt * _time_scale
	while _dt_accum >= _tick_dt:
		_step_tick(_tick_dt)
		_dt_accum -= _tick_dt


## Executes a single sim tick (deterministic order).
## [param dt] Tick delta seconds.
func _step_tick(dt: float) -> void:
	_tick_idx += 1

	# Build alive unit lists once per tick
	var alive_friends: Array[ScenarioUnit] = []
	var alive_enemies: Array[ScenarioUnit] = []
	for su in _friendlies:
		if not su.is_dead():
			alive_friends.append(su)
	for su in _enemies:
		if not su.is_dead():
			alive_enemies.append(su)

	_process_orders()
	var moved_units := _update_movement(dt, alive_friends, alive_enemies)
	_update_logistics(dt)
	_update_los(alive_friends, alive_enemies, moved_units)
	_update_time(dt)
	_resolve_combat()
	_update_morale()
	_emit_events()
	_record_replay()
	_mission_complete_check(dt)

	trigger_engine.tick(dt)
	Game.resolution.tick(dt)


## Pops ready orders and routes them via the OrdersRouter.
func _process_orders() -> void:
	var order_ready := _orders.pop_many(16)
	for o in order_ready:
		_router.apply(o)


## Advances movement for all sides and emits unit snapshots.
func _update_movement(
	dt: float, alive_friends: Array[ScenarioUnit], alive_enemies: Array[ScenarioUnit]
) -> Dictionary:
	var moved_units: Dictionary = {}

	if movement_adapter == null:
		return moved_units

	# Track positions before movement
	var positions_before: Dictionary = {}
	for su in alive_friends + alive_enemies:
		positions_before[su.id] = su.position_m

	# Tick movement
	movement_adapter.tick_units(alive_friends, dt)
	movement_adapter.tick_units(alive_enemies, dt)

	# Emit updates only for units that moved
	for su in alive_friends:
		var pos_before: Variant = positions_before.get(su.id)
		if pos_before == null or su.position_m.distance_to(pos_before) > 0.01:
			moved_units[su.id] = true
			emit_signal("unit_updated", su.id, _snapshot_unit(su))

	for su in alive_enemies:
		var pos_before: Variant = positions_before.get(su.id)
		if pos_before == null or su.position_m.distance_to(pos_before) > 0.01:
			moved_units[su.id] = true
			emit_signal("unit_updated", su.id, _snapshot_unit(su))

	return moved_units


## Get or create cached contact key for a pair of unit IDs.
func _get_contact_key(id_a: String, id_b: String) -> String:
	var cache_key := "%s|%s" % [id_a, id_b]
	if not _contact_key_cache.has(cache_key):
		_contact_key_cache[cache_key] = cache_key
	return _contact_key_cache[cache_key]


## Computes LOS contact pairs once per tick and emits contact events.
## Optimized to only check LOS between units when at least one has moved.
func _update_los(
	alive_friends: Array[ScenarioUnit], alive_enemies: Array[ScenarioUnit], moved_units: Dictionary
) -> void:
	if los_adapter == null:
		return

	# Update position cache for moved units
	for unit_id in moved_units.keys():
		var unit: ScenarioUnit = _units_by_id.get(unit_id)
		if unit:
			_unit_positions[unit_id] = unit.position_m

	# Build new contact pairs - only check LOS if at least one unit moved
	var new_contacts: PackedStringArray = []
	var old_contacts_dict: Dictionary = {}

	# Convert old contacts to dictionary for fast lookup
	for contact in _last_contacts:
		old_contacts_dict[contact] = true

	# Check all friend-enemy pairs (use alive arrays to skip dead unit checks)
	for f in alive_friends:
		for e in alive_enemies:
			# Use cached string key to avoid repeated string formatting
			var key := _get_contact_key(f.id, e.id)
			var f_moved := moved_units.has(f.id)
			var e_moved := moved_units.has(e.id)

			# If neither moved, keep existing contact state
			if not f_moved and not e_moved:
				if old_contacts_dict.has(key):
					new_contacts.append(key)
				continue

			# At least one moved - check LOS
			if los_adapter.has_los(f, e):
				new_contacts.append(key)

	_last_contacts = new_contacts
	_contact_pairs.clear()

	for key in _last_contacts:
		var parts := key.split("|")
		_contact_pairs.append({"attacker": parts[0], "defender": parts[1]})

		# Emit signal only for new contacts
		if not old_contacts_dict.has(key):
			emit_signal("contact_reported", parts[0], parts[1])


## Resolves combat for current contact pairs (range/logic inside controller).
## Emits [signal engagement_reported] for damage > 0.
func _resolve_combat() -> void:
	if combat_controller == null:
		return
	for key in _last_contacts:
		var parts := key.split("|")
		var a: ScenarioUnit = _units_by_id.get(parts[0])
		var d: ScenarioUnit = _units_by_id.get(parts[1])
		if a == null or d == null:
			continue
		if a.is_dead() or d.is_dead():
			continue
		var dmg: Variant = combat_controller.calculate_damage(a, d)
		var dmg_value := 0.0

		if typeof(dmg) == TYPE_DICTIONARY:
			dmg_value = float(dmg.get("damage", 0.0))
			var f := int(d.unit.strength * d.state_strength)
			var e := int(a.unit.strength * a.state_strength)
			if f != 0 or e != 0:
				Game.resolution.add_casualties(f, e)

			if bool(d.state_strength == 0):
				if d.affiliation == ScenarioUnit.Affiliation.FRIEND:
					Game.resolution.add_units_lost(1)
		else:
			dmg_value = float(dmg)

		if dmg_value > 0.0:
			emit_signal("engagement_reported", a.id, d.id, dmg_value)

		# Also allow the defender to attack the attacker in the same contact tick
		if not (a == null or d == null) and not (a.is_dead() or d.is_dead()):
			var dmg2: Variant = combat_controller.calculate_damage(d, a)
			var dmg_value2 := 0.0
			if typeof(dmg2) == TYPE_DICTIONARY:
				dmg_value2 = float(dmg2.get("damage", 0.0))
			else:
				dmg_value2 = float(dmg2)
			if dmg_value2 > 0.0:
				emit_signal("engagement_reported", d.id, a.id, dmg_value2)


## Ticks logistics systems and updates positions for proximity logic.
## [param dt] Step delta seconds.
func _update_logistics(dt: float) -> void:
	if ammo_system:
		for su: ScenarioUnit in _friendlies + _enemies:
			ammo_system.set_unit_position(su.id, _v3_from_m(su.position_m))
		ammo_system.tick(dt)

	if fuel_system:
		fuel_system.tick(dt)

	if artillery_controller:
		for su: ScenarioUnit in _friendlies + _enemies:
			artillery_controller.set_unit_position(su.id, su.position_m)
		artillery_controller.tick(dt)

	if engineer_controller:
		for su: ScenarioUnit in _friendlies + _enemies:
			engineer_controller.set_unit_position(su.id, su.position_m)
		engineer_controller.tick(dt)


## Pairs in contact this tick: Array of { attacker: String, defender: String }.
func get_current_contacts() -> Array:
	return _contact_pairs.duplicate()


## Get enemy units that a specific unit can see (has LOS to).
## [param unit_id] Unit ID to get contacts for.
## [return] Array of ScenarioUnit enemies in LOS.
func get_contacts_for_unit(unit_id: String) -> Array:
	var contacts: Array = []
	for pair in _contact_pairs:
		if pair.get("attacker", "") == unit_id:
			var enemy_id := str(pair.get("defender", ""))
			var enemy: ScenarioUnit = _units_by_id.get(enemy_id)
			if enemy != null:
				contacts.append(enemy)
	return contacts


## Updates morale (placeholder).
func _update_morale() -> void:
	pass


## Advance world time
func _update_time(dt: float) -> void:
	environment_controller.tick(dt)


## Emits per-tick radio/log events (placeholder).
func _emit_events() -> void:
	pass


## Check if mission is complete.
## [param dt] Time since last tick.
func _mission_complete_check(dt: float) -> void:
	if _state != State.RUNNING:
		return
	var d := Game.resolution.to_summary_payload()
	var prim: Array = d.get("primary_objectives", [])
	var objs: Dictionary = d.get("objectives", {})
	if prim.is_empty():
		return

	var all_success := true
	var all_failed := true
	for id in prim:
		var st := int(objs.get(id, MissionResolution.ObjectiveState.PENDING))
		if st != MissionResolution.ObjectiveState.SUCCESS:
			all_success = false
		if st != MissionResolution.ObjectiveState.FAILED:
			all_failed = false

	var should_end := all_success or all_failed
	if should_end:
		_mission_complete_accum += dt
		if _mission_complete_accum >= auto_end_grace_s:
			complete(all_failed)
	else:
		_mission_complete_accum = 0.0


## Records a compact snapshot for replays.
func _record_replay() -> void:
	var snap := {"tick": _tick_idx, "units": {}}
	for su in _friendlies + _enemies:
		snap.units[su.id] = {
			"pos": su.position_m,
			"state": su.move_state(),
			"morale": su.unit.morale if su.unit else 1.0
		}
	_replay.append(snap)


## Enqueue structured orders parsed elsewhere.
## [param orders] Array of order dictionaries.
## [return] Number of orders accepted.
func queue_orders(orders: Array) -> int:
	return _orders.enqueue_many(orders, _playable_by_callsign)


## Bind Radio and Parser so voice results are queued automatically.
## [param radio] Radio node emitting `radio_result`.
## [param parser] Parser node emitting `parsed(Array)` and `parse_error(String)`.
func bind_radio(radio: Radio, parser: Node) -> void:
	if radio and not radio.radio_result.is_connected(parser.parse):
		radio.radio_result.connect(parser.parse)
	if parser and not parser.parsed.is_connected(func(orders): queue_orders(orders)):
		parser.parsed.connect(func(orders): queue_orders(orders))
	if (
		parser
		and not parser.parse_error.is_connected(
			func(msg): emit_signal("radio_message", "error", msg)
		)
	):
		parser.parse_error.connect(func(msg): emit_signal("radio_message", "error", msg))

	# Bind radio to trigger engine for raw command matching
	if trigger_engine and radio:
		trigger_engine.bind_radio(radio)
		# Also listen for custom commands with trigger IDs
		if not radio.radio_raw_command.is_connected(_on_radio_command_for_triggers):
			radio.radio_raw_command.connect(_on_radio_command_for_triggers)


## Pause simulation.
func pause() -> void:
	if _state == State.RUNNING:
		_transition(_state, State.PAUSED)


## Resume simulation.
func resume() -> void:
	if _state == State.PAUSED:
		_transition(_state, State.RUNNING)


## Start simulation from INIT state.
func start() -> void:
	if _state == State.INIT:
		_transition(_state, State.PAUSED)

		var start_s := _scenario.second + _scenario.minute * 60 + _scenario.hour * 60 * 60
		environment_controller.time_of_day = start_s
		environment_controller.wind_direction = _scenario.wind_dir
		environment_controller.wind_speed = _scenario.wind_dir
		environment_controller.rain_intensity = _scenario.rain


## Set simulation time scale (1.0 = normal, 2.0 = 2x speed).
func set_time_scale(scale: float) -> void:
	_time_scale = max(0.0, scale)


## Get current simulation time scale (1.0 = normal, 2.0 = 2x speed, 0.0 = paused).
## [return] Current time scale multiplier.
func get_time_scale() -> float:
	return _time_scale


## Step one tick while paused.
func step() -> void:
	if _state == State.PAUSED:
		_step_tick(_tick_dt)


## Complete mission.
func complete(_failed: bool) -> void:
	if _state != State.COMPLETED:
		_transition(_state, State.COMPLETED)


## Get current simulation state.
## [return] Current State enum value.
func get_state() -> State:
	return _state


## Current tick index.
## [return] Tick number.
func get_tick() -> int:
	return _tick_idx


## Mission clock in seconds.
## [return] Elapsed mission time.
func get_mission_time_s() -> float:
	return float(_tick_idx) * _tick_dt


## Shallow snapshot of a unit for UI.
## [param unit_id] ScenarioUnit id.
## [return] Snapshot dictionary.
func get_unit_snapshot(unit_id: String) -> Dictionary:
	var su: ScenarioUnit = _units_by_id.get(unit_id)
	return _snapshot_unit(su)


## Snapshots of all units.
## [return] Array of snapshot dictionaries.
func get_unit_snapshots() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	for su in _friendlies + _enemies:
		out.append(_snapshot_unit(su))
	return out


## Outcome status string.
## [return] `"in_progress"` or `"completed"`.
func get_outcome_status() -> String:
	return "in_progress" if _state in [State.INIT, State.RUNNING, State.PAUSED] else "completed"


## Set RNG seed (determinism).
## [param new_rng_seed] Seed value.
func set_rng_seed(new_rng_seed: int) -> void:
	rng_seed = new_rng_seed
	_rng.seed = new_rng_seed


## Get RNG seed.
## [return] Current RNG seed.
func get_rng_seed() -> int:
	return _rng.seed


## Build a compact unit snapshot.
## [param su] ScenarioUnit instance (nullable).
## [return] Snapshot dictionary or empty if null.
func _snapshot_unit(su: ScenarioUnit) -> Dictionary:
	if su == null:
		return {}
	var strength := su.unit.strength * su.state_strength
	var destroyed := su.is_dead()

	return {
		"id": su.id,
		"callsign": su.callsign,
		"pos_m": su.position_m,
		"aff": int(su.affiliation),
		"state": int(su.move_state()),
		"strength": strength,
		"dead": destroyed or strength <= 0.0
	}


## Apply a state transition and emit [signal mission_state_changed].
## [param prev] Previous state.
## [param next] Next state.
func _transition(prev: State, next: State) -> void:
	_state = next
	emit_signal("mission_state_changed", prev, next)
	LogService.info(
		"mission_state_changed: %s" % {"prev": State.keys()[prev], "next": State.keys()[next]},
		"SimWorld.gd:285"
	)


## Planned path for a unit (for debug).
## [param uid] Unit id.
## [return] PackedVector2Array of path points (meters).
func get_unit_debug_path(uid: String) -> PackedVector2Array:
	var su: ScenarioUnit = _units_by_id.get(uid)
	if su == null:
		return []
	return su.move_path


## Current XZ position to 3D vector for systems needing 3D.
func _v3_from_m(p_m: Vector2) -> Vector3:
	return Vector3(p_m.x, 0.0, p_m.y)


## Initialize mission-specific voice grammar with STT and OrdersParser.
## [br][br]
## Collects and registers:
## [br]1. Custom commands from [member ScenarioData.custom_commands]
## [br]2. Unit callsigns from scenario units
## [br]3. Terrain labels from [member TerrainData.labels]
## [br][br]
## Updates:
## [br]- [OrdersParser] via [method OrdersParser.register_custom_command]
## [br]- [NARules] via [method NARules.set_mission_overrides]
## [br]- [STTService] via [method STTService.update_wordlist] with all collected words
## [br][br]
## [b]Called automatically by [method init_world] during mission initialization.[/b]
## [param scenario] Scenario with units, terrain, and custom commands.
func _init_custom_commands(scenario: ScenarioData) -> void:
	# Get parser reference (via router's export or find in tree)
	var parser: OrdersParser = null
	if _router.get_parent():
		for child in _router.get_parent().get_children():
			if child is OrdersParser:
				parser = child
				break

	# Collect custom command keywords and extra grammar
	var custom_actions: Dictionary = {}
	var extra_words: Array[String] = []

	for cmd in scenario.custom_commands:
		if cmd is CustomCommand and cmd.keyword != "":
			# Register with parser if available
			if parser:
				var metadata := {"trigger_id": cmd.trigger_id, "route_as_order": cmd.route_as_order}
				parser.register_custom_command(cmd.keyword, metadata)

			# Collect for NARules grammar
			extra_words.append(cmd.keyword)
			extra_words.append_array(cmd.additional_grammar)

			# If route_as_order, add to action_synonyms
			if cmd.route_as_order:
				custom_actions[cmd.keyword.to_lower()] = OrdersParser.OrderType.CUSTOM

	# Set mission overrides in NARules for STT grammar
	if not custom_actions.is_empty() or not extra_words.is_empty():
		NARules.set_mission_overrides(custom_actions, extra_words)

	# Collect unit callsigns
	var callsigns: Array[String] = []
	for su in scenario.units:
		if su != null and su.callsign != "":
			callsigns.append(su.callsign)
	for su in scenario.playable_units:
		if su != null and su.callsign != "":
			callsigns.append(su.callsign)

	# Collect terrain labels
	var labels: Array[String] = []
	if scenario.terrain and scenario.terrain.labels:
		for label in scenario.terrain.labels:
			var txt := str(label.get("text", "")).strip_edges()
			if txt != "":
				labels.append(txt)

	# Update STT recognizer with complete mission grammar
	# Includes: base grammar, custom commands, callsigns, and terrain labels
	STTService.update_wordlist(callsigns, labels)

	LogService.info(
		(
			"Updated STT grammar: %d custom commands, %d callsigns, %d labels"
			% [scenario.custom_commands.size(), callsigns.size(), labels.size()]
		),
		"SimWorld.gd"
	)


## Handle radio commands and auto-activate triggers for matching custom commands.
## Connected to [signal Radio.radio_raw_command] in [method bind_radio].
## [param text] Raw text from STT.
func _on_radio_command_for_triggers(text: String) -> void:
	if not _scenario:
		return
	var normalized := text.strip_edges().to_lower()
	for cmd in _scenario.custom_commands:
		if cmd is CustomCommand and cmd.keyword != "" and cmd.trigger_id != "":
			if normalized == cmd.keyword.to_lower():
				if trigger_engine:
					trigger_engine.activate_trigger(cmd.trigger_id)
					LogService.trace(
						(
							"Custom command '%s' activated trigger '%s'"
							% [cmd.keyword, cmd.trigger_id]
						),
						"SimWorld.gd"
					)
				break


## Register all units with logistics systems and bind hooks.
func _register_logistics_units() -> void:
	if fuel_system:
		for su: ScenarioUnit in _friendlies + _enemies:
			fuel_system.register_scenario_unit(su)
			su.bind_fuel_system(fuel_system)

	if ammo_system:
		for su: ScenarioUnit in _friendlies + _enemies:
			ammo_system.register_unit(su)
			ammo_system.set_unit_position(su.id, _v3_from_m(su.position_m))

	if artillery_controller:
		artillery_controller.bind_ammo_system(ammo_system)
		if los_adapter:
			artillery_controller.bind_los_adapter(los_adapter)
		for su: ScenarioUnit in _friendlies + _enemies:
			artillery_controller.register_unit(su.id, su)
			artillery_controller.set_unit_position(su.id, su.position_m)

	if engineer_controller:
		engineer_controller.bind_ammo_system(ammo_system)
		for su: ScenarioUnit in _friendlies + _enemies:
			engineer_controller.register_unit(su.id, su)
			engineer_controller.set_unit_position(su.id, su.position_m)


## State change callback: finalize mission resolution.
## [param prev] Previous state.
## [param next] Next state.
func _on_state_change_for_resolution(_prev: State, next: State) -> void:
	if next == State.COMPLETED:
		Game.end_scenario_and_go_to_debrief()


## Router callback: order applied.
## [param order] Order dictionary.
func _on_order_applied(order: Dictionary) -> void:
	var order_type: int = int(order.get("type", -1))
	# Skip generic acknowledgement for orders that have specific feedback
	# (ENGINEER, FIRE have their own controller signals)
	if order_type == OrdersParser.OrderType.ENGINEER or order_type == OrdersParser.OrderType.FIRE:
		return
	emit_signal("radio_message", "debug", "Order applied: %s" % order.get("type", "?"))
	var hr_order: String = OrdersParser.OrderType.keys()[order_type]
	LogService.info("radio_message: %s" % {"Order applied": hr_order}, "SimWorld.gd:293")


## Router callback: order failed.
## [param _order] Order dictionary (unused).
## [param reason] Failure reason.
func _on_order_failed(_order: Dictionary, reason: String) -> void:
	emit_signal("radio_message", "debug", "Order failed (%s)." % reason)
	LogService.warning("radio_message: %s" % {"Order failed": reason}, "SimWorld.gd:299")
