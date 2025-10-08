class_name SimWorld
extends Node
## Authoritative deterministic simulation loop (INIT→RUNNING→PAUSED→COMPLETED).
## Ticks subsystems in order: process_orders → update_movement → update_los →
## resolve_combat → update_morale → emit_events → radio_feedback.
## Exposes read-only queries for UI and an event bus via signals.

## Event bus for UI/logging
signal unit_updated(unit_id: String, snapshot: Dictionary)
signal contact_reported(attacker_id: String, defender_id: String)
signal radio_message(level: String, text: String)
signal mission_state_changed(prev: State, next: State)
## Emitted when damage > 0 is applied attacker→defender this tick.
signal engagement_reported(attacker_id: String, defender_id: String, damage: float)

## Simulation state machine
enum State { INIT, RUNNING, PAUSED, COMPLETED }

## Fixed tick rate (Hz)
@export var tick_hz := 5.0
## Initial RNG seed (0 → randomize)
@export var rng_seed: int = 0
## LOS/Combat/Movement bridges
@export var los_adapter: LOSAdapter
@export var movement_adapter: MovementAdapter
@export var combat_controller: CombatController
@export var _router: OrdersRouter

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


func _ready() -> void:
	_tick_dt = 1.0 / max(tick_hz, 0.001)
	if rng_seed == 0:
		_rng.randomize()
	else:
		_rng.seed = rng_seed

	_router.order_applied.connect(_on_order_applied)
	_router.order_failed.connect(_on_order_failed)

	set_process(true)


## Initialize world from [param scenario]. Also wires unit indices.
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


func _process(dt: float) -> void:
	if _state != State.RUNNING:
		return
	_dt_accum += dt
	while _dt_accum >= _tick_dt:
		_step_tick(_tick_dt)
		_dt_accum -= _tick_dt


## Single deterministic sim tick.
func _step_tick(dt: float) -> void:
	_tick_idx += 1
	_process_orders()
	_update_movement(dt)
	_update_los()
	_resolve_combat()
	_update_morale()
	_emit_events()
	_record_replay()


## Consume queued orders and route them.
func _process_orders() -> void:
	var order_ready := _orders.pop_many(16)
	for o in order_ready:
		_router.apply(o)


## Drive unit movement.
func _update_movement(dt: float) -> void:
	if movement_adapter == null:
		return
	movement_adapter.tick_units(_friendlies, dt)
	movement_adapter.tick_units(_enemies, dt)
	for su in _friendlies + _enemies:
		emit_signal("unit_updated", su.id, _snapshot_unit(su))


## Compute LOS contacts once per tick.
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


## Resolve combat for contact pairs that are in range.
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
		if dmg > 0.0:
			emit_signal("engagement_reported", a.id, d.id)


## Stub morale update hook (placeholder for now).
func _update_morale() -> void:
	pass


## Flush per-tick messages to RadioFeedback (message level is free-form: info/warn/error).
func _emit_events() -> void:
	pass


## Record a compact snapshot for replays.
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
func queue_orders(orders: Array) -> int:
	return _orders.enqueue_many(orders, _playable_by_callsign)


## Convenience: bind a Radio + OrdersParser pair so spoken results route into the queue.
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


## Complete mission (stub — external objective resolver should call this).
func complete() -> void:
	if _state != State.COMPLETED:
		_transition(_state, State.COMPLETED)


## Get current tick index.
func get_tick() -> int:
	return _tick_idx


## Get mission clock in seconds.
func get_mission_time_s() -> float:
	return float(_tick_idx) * _tick_dt


## Return a shallow snapshot of a unit for UI.
func get_unit_snapshot(unit_id: String) -> Dictionary:
	var su: ScenarioUnit = _units_by_id.get(unit_id)
	return _snapshot_unit(su)


## Return snapshots of all units.
func get_unit_snapshots() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	for su in _friendlies + _enemies:
		out.append(_snapshot_unit(su))
	return out


## Out-of-band outcome status (stub).
func get_outcome_status() -> String:
	return "in_progress" if _state in [State.INIT, State.RUNNING, State.PAUSED] else "completed"


## Read/write RNG seed for determinism.
func set_rng_seed(new_rng_seed: int) -> void:
	rng_seed = new_rng_seed
	_rng.seed = new_rng_seed


func get_rng_seed() -> int:
	return _rng.seed


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


func _transition(prev: State, next: State) -> void:
	_state = next
	emit_signal("mission_state_changed", prev, next)
	LogService.info("mission_state_changed: %s" % {"prev": prev, "next": next}, "SimWorld.gd:285")


## Returns Array[Vector2] planned path in meters (for debug).
func get_unit_debug_path(uid: String) -> PackedVector2Array:
	var su: ScenarioUnit = _units_by_id.get(uid)
	if su == null:
		return []
	return su.move_path


func _on_order_applied(order: Dictionary) -> void:
	emit_signal("radio_message", "info", "Order applied: %s" % order.get("type", "?"))
	var hr_order: String = OrdersParser.OrderType.keys()[int(order.get("type", -1))]
	LogService.info("radio_message: %s" % {"Order applied": hr_order}, "SimWorld.gd:293")


func _on_order_failed(_order: Dictionary, reason: String) -> void:
	emit_signal("radio_message", "error", "Order failed (%s)." % reason)
	LogService.warning("radio_message: %s" % {"Order failed": reason}, "SimWorld.gd:299")
