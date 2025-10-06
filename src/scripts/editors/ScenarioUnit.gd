extends Resource
class_name ScenarioUnit

## Unit Rules of Engagement
enum CombatMode { forced_hold_fire, do_not_fire_unless_fired_upon, open_fire }
## Unit movement behaviour
enum Behaviour { careless, safe, aware, combat, stealth }
## Unit affiliation
enum Affiliation { friend, enemy }
## Runtime movement states.
enum MoveState { idle, planning, moving, paused, blocked, arrived }

## Unique identifier
@export var id: String
## Callsign
@export var callsign: String
## Unit Data
@export var unit: UnitData
## Unit Position
@export var position_m: Vector2
## Unit Affiliation
@export var affiliation: Affiliation
## Unit Combat Mode
@export var combat_mode: CombatMode = CombatMode.open_fire
## Unit Behaviour
@export var behaviour: Behaviour = Behaviour.safe

## Emitted when a path is planned
signal move_planned(dest_m: Vector2, eta_s: float)
## Emitted when movement begins
signal move_started(dest_m: Vector2)
## Emitted every tick while moving
signal move_progress(pos_m: Vector2, eta_s: float)
## Emitted on successful arrival
signal move_arrived(dest_m: Vector2)
## Emitted when movement cannot proceed
signal move_blocked(reason: String)
## Emitted when paused
signal move_paused()
## Emitted when resumed
signal move_resumed()

const ARRIVE_EPSILON := 1.0

var _move_state: MoveState = MoveState.idle
var _move_dest_m: Vector2 = Vector2.ZERO
var _move_path: PackedVector2Array = []
var _move_path_idx := 0
var _move_last_eta_s := 0.0
var _move_paused := false

## FuelSystem
## FuelSystem provider used to scale speed at LOW/CRITICAL and 0 at EMPTY.
var _fuel: FuelSystem = null

## Bind a FuelSystem instance at runtime.
func bind_fuel_system(fs: FuelSystem) -> void:
	_fuel = fs

## Plan a path from current position to dest_m using PathGrid.
func plan_move(grid: PathGrid, dest_m: Vector2) -> bool:
	if grid == null:
		emit_signal("move_blocked", "no_grid")
		return false
	if unit == null:
		emit_signal("move_blocked", "no_unit")
		return false
	if unit.speed_kph <= 0.0:
		emit_signal("move_blocked", "no_speed")
		return false
	if position_m.distance_to(dest_m) <= ARRIVE_EPSILON:
		_move_dest_m = dest_m
		_move_path = [position_m, dest_m]
		_move_path_idx = 1
		_move_state = MoveState.arrived
		position_m = dest_m
		emit_signal("move_arrived", dest_m)
		return true
	_move_dest_m = dest_m
	var p := grid.find_path_m(position_m, dest_m)
	if p.is_empty():
		_move_state = MoveState.blocked
		_move_path = []
		_move_path_idx = 0
		emit_signal("move_blocked", "no_path")
		return false
	_move_path = p
	_move_path_idx = 0
	_move_state = MoveState.planning
	_move_last_eta_s = estimate_eta_s(grid)
	emit_signal("move_planned", dest_m, _move_last_eta_s)
	return true

## Start movement; will plan if needed or if dest is provided.
func start_move(grid: PathGrid, dest_m: Vector2 = Vector2(INF, INF)) -> void:
	if dest_m.x == INF:
		if _move_path.is_empty() and not plan_move(grid, _move_dest_m):
			return
	else:
		if not plan_move(grid, dest_m):
			return
	_move_paused = false
	_move_state = MoveState.moving
	emit_signal("move_started", _move_dest_m)

## Pause.
func pause_move() -> void:
	if _move_state == MoveState.moving:
		_move_paused = true
		_move_state = MoveState.paused
		emit_signal("move_paused")

## Resume.
func resume_move() -> void:
	if _move_state == MoveState.paused:
		_move_paused = false
		_move_state = MoveState.moving
		emit_signal("move_resumed")

## Cancel ongoing movement.
func cancel_move() -> void:
	_move_path = []
	_move_path_idx = 0
	_move_dest_m = position_m
	_move_state = MoveState.idle

## Advance movement by dt seconds on PathGrid (virtual position only).
func tick(dt: float, grid: PathGrid) -> void:
	if _move_state != MoveState.moving or _move_paused or _move_path.is_empty():
		return

	var cur := position_m
	var speed := _speed_here_mps(grid, cur)
	if speed <= 0.0:
		_move_state = MoveState.blocked
		emit_signal("move_blocked", "blocked_cell")
		return

	var remain := speed * dt
	while remain > 0.0 and _move_path_idx < _move_path.size():
		var tgt := _move_path[_move_path_idx]
		var d := cur.distance_to(tgt)
		if d <= remain:
			remain -= d
			cur = tgt
			_move_path_idx += 1
		else:
			var dir := (tgt - cur).normalized()
			cur += dir * remain
			remain = 0.0

	position_m = cur
	_move_last_eta_s = estimate_eta_s(grid)
	emit_signal("move_progress", position_m, _move_last_eta_s)

	if _move_path_idx >= _move_path.size() or position_m.distance_to(_move_dest_m) <= ARRIVE_EPSILON:
		_move_state = MoveState.arrived
		position_m = _move_dest_m
		emit_signal("move_arrived", _move_dest_m)

## Estimate remaining time using grid weights (cheap mid-segment sampling).
func estimate_eta_s(grid: PathGrid) -> float:
	if grid == null or _move_path.size() < 1:
		return 0.0
	var pts := PackedVector2Array()
	pts.append(position_m)
	for i in range(_move_path_idx, _move_path.size()):
		pts.append(_move_path[i])
	return _estimate_time_along(grid, pts)

## Query helpers (for UI/AI).
func move_state() -> MoveState: return _move_state
func destination_m() -> Vector2: return _move_dest_m
func current_path() -> PackedVector2Array: return _move_path
func path_index() -> int: return _move_path_idx

## Terrain-modified speed at a point using PathGrid weight.
## _speed_here_mps also includes speed penalties for low fuel
func _speed_here_mps(grid: PathGrid, p_m: Vector2) -> float:
	if grid == null or grid._astar == null:
		var v := _kph_to_mps(unit.speed_kph)
		if _fuel != null:
			v *= _fuel.speed_mult(id)
		return v

	var c := grid.world_to_cell(p_m)
	if not grid._in_bounds(c):
		var v := _kph_to_mps(unit.speed_kph)
		if _fuel != null:
			v *= _fuel.speed_mult(id)
		return v

	if grid._astar.is_in_boundsv(c) and grid._astar.is_point_solid(c):
		return 0.0

	var w: float = max(grid._astar.get_point_weight_scale(c), 0.001)
	var v := _kph_to_mps(unit.speed_kph) / w
	if _fuel != null:
		v *= _fuel.speed_mult(id)
	return v

## Sum time for a polyline using mid-segment speed.
func _estimate_time_along(grid: PathGrid, pts: PackedVector2Array) -> float:
	if pts.size() < 2: return 0.0
	var t := 0.0
	for i in range(1, pts.size()):
		var a := pts[i - 1]
		var b := pts[i]
		var d := a.distance_to(b)
		var mid := (a + b) * 0.5
		var v := _speed_here_mps(grid, mid)
		if v <= 0.0: return INF
		t += d / v
	return t

## Convert kph to mps
func _kph_to_mps(speed_kph: float) -> float:
	return max(0.0, speed_kph) * (1000.0 / 3600.0)

## Serialize to JSON.
func serialize() -> Dictionary:
	return {
		"id": id,
		"unit_id": unit.id,
		"callsign": callsign,
		"position": ContentDB.v2(position_m),
		"affiliation": int(affiliation),
		"combat_mode": int(combat_mode),
		"behaviour": int(behaviour)
	}

## Deserialzie from JSON.
static func deserialize(d: Dictionary) -> ScenarioUnit:
	var u := ScenarioUnit.new()
	u.id = d.get("id")
	u.unit = ContentDB.get_unit(d.get("unit_id"))
	u.callsign = d.get("callsign", "unit")
	u.position_m = ContentDB.v2_from(d.get("position"))
	u.affiliation = int(d.get("affiliation")) as Affiliation
	u.combat_mode = int(d.get("combat_mode")) as CombatMode
	u.behaviour = int(d.get("behaviour")) as Behaviour
	return u
