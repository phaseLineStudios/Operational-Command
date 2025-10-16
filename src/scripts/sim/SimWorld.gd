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
signal radio_message(level: String, text: String)
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
## Combat controller.
@export var trigger_engine: TriggerEngine
## Orders router.
@export var _router: OrdersRouter
## Grace period before ending (seconds) to avoid flapping.
@export var auto_end_grace_s := 2.0

var _state: State = State.INIT
var _dt_accum := 0.0
var _tick_dt := 0.2
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
var _mission_complete_accum := 0.0


## Initializes tick timing/RNG and wires router signals. Starts processing.
func _ready() -> void:
	_tick_dt = 1.0 / max(tick_hz, 0.001)
	if rng_seed == 0:
		_rng.randomize()
	else:
		_rng.seed = rng_seed

	_router.order_applied.connect(_on_order_applied)
	_router.order_failed.connect(_on_order_failed)

	set_process(true)


## Initialize world from a scenario and build unit indices.
## [param scenario] ScenarioData to load.
func init_world(scenario: ScenarioData) -> void:
	_scenario = scenario
	_units_by_id.clear()
	_units_by_callsign.clear()
	_friendlies.clear()
	_enemies.clear()

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
	_transition(State.INIT, State.RUNNING)


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
		return
	_dt_accum += dt
	while _dt_accum >= _tick_dt:
		_step_tick(_tick_dt)
		_dt_accum -= _tick_dt


## Executes a single sim tick (deterministic order).
## [param dt] Tick delta seconds.
func _step_tick(dt: float) -> void:
	_tick_idx += 1
	_process_orders()
	_update_movement(dt)
	_update_los()
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
func _update_movement(dt: float) -> void:
	if movement_adapter == null:
		return
	movement_adapter.tick_units(_friendlies, dt)
	movement_adapter.tick_units(_enemies, dt)
	for su in _friendlies + _enemies:
		emit_signal("unit_updated", su.id, _snapshot_unit(su))


## Computes LOS contact pairs once per tick and emits contact events.
func _update_los() -> void:
	if los_adapter == null:
		return
	var pairs := los_adapter.contacts_between(_friendlies, _enemies)
	_last_contacts.clear()
	for p in pairs:
		var a: ScenarioUnit = p.attacker
		var d: ScenarioUnit = p.defender
		var key := "%s|%s" % [a.id, d.id]
		_last_contacts.append(key)
		emit_signal("contact_reported", a.id, d.id)


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

		var dmg := combat_controller.calculate_damage(a, d)
		if dmg <= 0.0:
			continue

		emit_signal("engagement_reported", a.id, d.id)

		if typeof(dmg) == TYPE_DICTIONARY:
			var f := int(d.unit.strength * d.unit.state_strength)
			var e := int(a.unit.strength * a.unit.state_strength)
			if f != 0 or e != 0:
				Game.resolution.add_casualties(f, e)

			if bool(d.unit.state_strength == 0):
				if d.affiliation == ScenarioUnit.Affiliation.FRIEND:
					Game.resolution.add_units_lost(1)


## Updates morale (placeholder).
func _update_morale() -> void:
	pass


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


## Pause simulation.
func pause() -> void:
	if _state == State.RUNNING:
		_transition(_state, State.PAUSED)


## Resume simulation.
func resume() -> void:
	if _state == State.PAUSED:
		_transition(_state, State.RUNNING)


## Step one tick while paused.
func step() -> void:
	if _state == State.PAUSED:
		_step_tick(_tick_dt)


## Complete mission.
func complete(_failed: bool) -> void:
	if _state != State.COMPLETED:
		_transition(_state, State.COMPLETED)


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
	return {
		"id": su.id,
		"callsign": su.callsign,
		"pos_m": su.position_m,
		"aff": int(su.affiliation),
		"state": int(su.move_state())
	}


## Apply a state transition and emit [signal mission_state_changed].
## [param prev] Previous state.
## [param next] Next state.
func _transition(prev: State, next: State) -> void:
	_state = next
	emit_signal("mission_state_changed", prev, next)
	LogService.info("mission_state_changed: %s" % {"prev": prev, "next": next}, "SimWorld.gd:285")


## Planned path for a unit (for debug).
## [param uid] Unit id.
## [return] PackedVector2Array of path points (meters).
func get_unit_debug_path(uid: String) -> PackedVector2Array:
	var su: ScenarioUnit = _units_by_id.get(uid)
	if su == null:
		return []
	return su.move_path


## State change callback: finalize mission resolution.
## [param prev] Previous state.
## [param next] Next state.
func _on_state_change_for_resolution(_prev: State, next: State) -> void:
	if next == State.COMPLETED:
		Game.end_scenario_and_go_to_debrief()


## Router callback: order applied.
## [param order] Order dictionary.
func _on_order_applied(order: Dictionary) -> void:
	emit_signal("radio_message", "info", "Order applied: %s" % order.get("type", "?"))
	var hr_order: String = OrdersParser.OrderType.keys()[int(order.get("type", -1))]
	LogService.info("radio_message: %s" % {"Order applied": hr_order}, "SimWorld.gd:293")


## Router callback: order failed.
## [param _order] Order dictionary (unused).
## [param reason] Failure reason.
func _on_order_failed(_order: Dictionary, reason: String) -> void:
	emit_signal("radio_message", "error", "Order failed (%s)." % reason)
	LogService.warning("radio_message: %s" % {"Order failed": reason}, "SimWorld.gd:299")
