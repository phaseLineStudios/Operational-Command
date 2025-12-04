class_name MovementAdapter
extends Node
## Movement adapter for pathfinding-based unit orders.
##
## @brief Plans and ticks movement using per-unit profiles (FOOT/WHEELED/
## TRACKED/RIVERINE), groups ticks by profile for performance, and resolves
## map label names into terrain positions for destination orders.
## @experimental

## Map lowercase mobility tags/strings to movement profiles.
const _PROFILE_BY_TAG := {
	"foot": TerrainBrush.MoveProfile.FOOT,
	"infantry": TerrainBrush.MoveProfile.FOOT,
	"wheeled": TerrainBrush.MoveProfile.WHEELED,
	"truck": TerrainBrush.MoveProfile.WHEELED,
	"apc": TerrainBrush.MoveProfile.WHEELED,
	"tracked": TerrainBrush.MoveProfile.TRACKED,
	"mbt": TerrainBrush.MoveProfile.TRACKED,
	"ifv": TerrainBrush.MoveProfile.TRACKED,
	"riverine": TerrainBrush.MoveProfile.RIVERINE,
	"boat": TerrainBrush.MoveProfile.RIVERINE,
}

## Terrain renderer providing the PathGrid and TerrainData.
@export var renderer: TerrainRender
## Default profile used when a unit has no explicit movement profile.
@export var default_profile: int = TerrainBrush.MoveProfile.FOOT
## Enable resolving String destinations using TerrainData.labels[].text.
@export var enable_label_destinations := true

## AI Agent Related Variables
## The Node3D that actually moves (usually the unit root).
@export var actor_path: NodePath
## Base speed before behaviour multipliers (meters per second).
@export var base_speed_mps: float = 4.0
## Stop when closer than this distance to a target.
@export var arrive_epsilon: float = 0.5
## Rotate actor to face velocity during movement.
@export var rotate_to_velocity: bool = true
## Time that must elapse after arriving in a hold area to consider it established.
@export var hold_settle_time: float = 1.0
## Dwell time on each patrol point before advancing.
@export var patrol_dwell_seconds: float = 0.5

var _actor: Node3D

# Behaviour mapping from AIAgent
var _speed_mult: float = 1.0
var _noise_level: float = 0.6

# Move state
var _moving: bool = false
var _move_target: Vector3 = Vector3.ZERO

# Hold state
var _holding: bool = false
var _hold_center: Vector3 = Vector3.ZERO
var _hold_radius: float = 0.0
var _hold_timer: float = 0.0

# Patrol state
var _patrol_running: bool = false
var _patrol_points: Array[Vector3] = []
var _patrol_ping_pong: bool = false
var _patrol_index: int = 0
var _patrol_forward: bool = true
var _patrol_segments_remaining: int = 0
var _patrol_dwell: float = 0.0
var _patrol_loop_forever: bool = false

var _grid: PathGrid
var _labels: Dictionary = {}


## Initialize grid hooks and build the label index.
func _ready() -> void:
	_grid = renderer.path_grid
	_refresh_label_index()

	if _grid and not _grid.is_connected("build_ready", Callable(self, "_on_grid_ready")):
		_grid.build_ready.connect(_on_grid_ready)

	if actor_path.is_empty():
		_actor = get_parent() as Node3D
	else:
		_actor = get_node_or_null(actor_path) as Node3D


func _physics_process(dt: float) -> void:
	if _actor == null:
		return

	# Patrol takes priority and drives _moving
	if _patrol_running:
		_tick_patrol(dt)

	# Move step
	if _moving:
		_step_move(dt)

	# Hold settle timer
	if _holding:
		_tick_hold(dt)


## Rebuilds the label lookup from TerrainData.labels.
## Stores: normalized_text -> Array[Vector2] (terrain meters).
func _refresh_label_index() -> void:
	_labels.clear()
	if not enable_label_destinations:
		return
	if renderer == null or renderer.data == null:
		return
	var labels := renderer.data.labels
	for label in labels:
		var txt := str(label.get("text", "")).strip_edges()
		var pos: Vector2 = label.get("pos", null)
		if txt == "" or typeof(pos) != TYPE_VECTOR2:
			continue
		var key := _norm_label(txt)
		if not _labels.has(key):
			_labels[key] = []
		_labels[key].append(pos)


## Normalizes label text for tolerant matching.
## Removes punctuation, collapses spaces, and lowercases.
## [param s] Original label text.
## [return] Normalized key.
func _norm_label(s: String) -> String:
	var t := s.strip_edges().to_lower()
	for bad in [
		",",
		".",
		":",
		";",
		"(",
		")",
		"[",
		"]",
		"'",
		'"',
		"?",
		"!",
		"@",
		"#",
		"$",
		"%",
		"^",
		"&",
		"*",
		"+",
		"=",
		"|",
		"\\"
	]:
		t = t.replace(bad, "")
	t = t.replace("-", " ").replace("_", " ").replace("/", " ")
	while t.find("  ") != -1:
		t = t.replace("  ", " ")
	return t


## Resolves a label phrase to a terrain position in meters.
## When multiple labels share the same text, picks the closest to origin.
## [param label_text] Label string to look up.
## [param origin_m] Optional origin (unit position) for tie-breaking.
## [return] Vector2 position if found, otherwise null.
func _resolve_label_to_pos(label_text: String, origin_m: Vector2 = Vector2.INF) -> Variant:
	if not enable_label_destinations:
		return null
	var key := _norm_label(label_text)
	if not _labels.has(key):
		return null
	var arr: Array = _labels[key]
	if arr.is_empty():
		return null
	if origin_m.is_finite():
		var best: Vector2 = arr[0]
		var best_d := best.distance_to(origin_m)
		for p in arr:
			var d := (p as Vector2).distance_to(origin_m)
			if d < best_d:
				best = p
				best_d = d
		return best
	return arr[0]


## Plans and starts movement to a map label.
## [param su] ScenarioUnit to move.
## [param label_text] Label name to resolve.
## [return] True if the order was accepted (or deferred), else false.
func plan_and_start_to_label(su: ScenarioUnit, label_text: String) -> bool:
	if su == null:
		return false
	var pos: Variant = _resolve_label_to_pos(label_text, su.position_m)
	if typeof(pos) == TYPE_VECTOR2:
		return plan_and_start(su, pos)
	LogService.warning("label not found: %s" % label_text, "MovementAdapter.gd:88")
	return false


## Plans and starts movement to either a Vector2 destination or a label.
## Also accepts {x,y} or {pos: Vector2} dictionaries.
## [param su] ScenarioUnit to move.
## [param dest] Vector2 | String | Dictionary destination.
## [return] True if the order was accepted (or deferred), else false.
func plan_and_start_any(su: ScenarioUnit, dest: Variant) -> bool:
	match typeof(dest):
		TYPE_VECTOR2:
			return plan_and_start(su, dest)
		TYPE_STRING:
			return plan_and_start_to_label(su, dest)
		TYPE_DICTIONARY:
			if dest.has("x") and dest.has("y"):
				return plan_and_start(su, Vector2(dest["x"], dest["y"]))
			if dest.has("pos"):
				var p: Vector2 = dest["pos"]
				if typeof(p) == TYPE_VECTOR2:
					return plan_and_start(su, p)
	return false


## Ensures PathGrid profiles needed by [param units] are available.
## Triggers async builds for any missing profiles.
func _prebuild_needed_profiles(units: Array[ScenarioUnit]) -> void:
	if _grid == null:
		return
	var wanted := {}
	for u in units:
		var p := u.unit.movement_profile
		wanted[p] = true
	for p in wanted.keys():
		if not _grid.has_profile(p):
			_grid.ensure_profile(p)


## Ticks unit movement grouped by profile (reduces grid switching).
## Skips groups whose profile grid is still building this frame.
## Auto-pauses units that are under fire (but not actively firing).
## [param units] Units to tick.
## [param dt] Delta time in seconds.
func tick_units(units: Array[ScenarioUnit], dt: float) -> void:
	if _grid == null or units.is_empty():
		return

	_prebuild_needed_profiles(units)

	var groups := {}
	for u in units:
		var p := u.unit.movement_profile
		if not groups.has(p):
			groups[p] = []
		groups[p].append(u)

	for p in groups.keys():
		if _grid.ensure_profile(p):
			_grid.use_profile(p)
			for u in groups[p]:
				# Auto-pause if unit is under fire (taking damage)
				# Note: We don't pause if the unit is actively firing back,
				# which is handled by the combat mode and engagement system.
				# This simple check just pauses movement when hit.
				if u.is_under_fire() and u.move_state() == ScenarioUnit.MoveState.MOVING:
					u.pause_move()

				u.tick(dt, _grid)


## Pauses current movement for a unit.
## [param su] ScenarioUnit to pause.
func cancel_move(su: ScenarioUnit) -> void:
	if su == null:
		return
	su.pause_move()


## Plans and immediately starts movement to [param dest_m].
## Defers start if the profile grid is still building.
## [param su] ScenarioUnit to move.
## [param dest_m] Destination in terrain meters.
## [return] True if planned (or deferred), false on error or plan failure.
func plan_and_start(su: ScenarioUnit, dest_m: Vector2) -> bool:
	if su == null or _grid == null:
		LogService.warning("unit or grid null", "MovementAdapter.gd:151")
		return false
	var p := su.unit.movement_profile
	if not _grid.ensure_profile(p):
		su.set_meta("_pending_start_dest", dest_m)
		su.set_meta("_pending_start_profile", p)
		return true
	_grid.use_profile(p)
	if su.plan_move(_grid, dest_m):
		su.start_move(_grid)
		return true
	LogService.warning("plan_move failed", "MovementAdapter.gd:163")
	return false


## Plans and starts direct straight-line movement without pathfinding.
## Defers start if the profile grid is still building.
## [param su] ScenarioUnit to move.
## [param dest_m] Destination in terrain meters.
## [return] True if planned (or deferred), false on error.
func plan_and_start_direct(su: ScenarioUnit, dest_m: Vector2) -> bool:
	if su == null or _grid == null:
		LogService.warning("unit or grid null", "MovementAdapter.gd")
		return false
	var p := su.unit.movement_profile
	if not _grid.ensure_profile(p):
		su.set_meta("_pending_start_dest", dest_m)
		su.set_meta("_pending_start_profile", p)
		su.set_meta("_pending_start_direct", true)
		return true
	_grid.use_profile(p)
	if su.plan_direct_move(_grid, dest_m):
		su.start_move(_grid)
		return true
	LogService.warning("plan_direct_move failed", "MovementAdapter.gd")
	return false


## Starts any deferred moves whose profile just finished building.
## [param profile] Movement profile that became available.
func _on_grid_ready(profile: int) -> void:
	var scen := Game.current_scenario
	if scen == null:
		return
	var all_units: Array = []
	all_units.append_array(scen.units)
	all_units.append_array(scen.playable_units)
	_grid.use_profile(profile)
	for su in all_units:
		if su == null:
			continue
		if (
			su.has_meta("_pending_start_profile")
			and int(su.get_meta("_pending_start_profile")) == profile
		):
			var dest_m: Vector2 = su.get_meta("_pending_start_dest")
			var is_direct: bool = su.get_meta("_pending_start_direct", false)
			su.remove_meta("_pending_start_profile")
			su.remove_meta("_pending_start_dest")
			su.remove_meta("_pending_start_direct")

			# Use direct or normal pathfinding
			var planned: bool = false
			if is_direct:
				planned = su.plan_direct_move(_grid, dest_m)
			else:
				planned = su.plan_move(_grid, dest_m)

			if planned:
				su.start_move(_grid)


## Behaviour mapping from AIAgent
func set_behaviour_params(speed_mult: float, _cover_bias_unused: float, noise_level: float) -> void:
	_speed_mult = speed_mult
	_noise_level = noise_level


## TaskMove
func request_move_to(dest: Vector3) -> void:
	_patrol_running = false
	_holding = false
	_move_target = dest
	_moving = true


func is_move_complete() -> bool:
	return not _moving


## TaskDefend
func request_hold_area(center: Vector3, radius: float) -> void:
	_patrol_running = false
	_holding = true
	_hold_center = center
	_hold_radius = max(radius, 0.0)
	_hold_timer = 0.0

	# If outside radius, move to nearest point on the circle, else stop immediately and start settling
	if _actor != null:
		var offset: Vector3 = _actor.global_position - center
		var dist: float = offset.length()
		if dist > _hold_radius + arrive_epsilon:
			var dir: Vector3 = offset.normalized()
			_move_target = center + dir * _hold_radius
			_moving = true
		else:
			_moving = false


func is_hold_established() -> bool:
	# Established when inside radius and settled long enough
	if _actor == null:
		return true
	var inside: bool = (
		_actor.global_position.distance_to(_hold_center) <= _hold_radius + arrive_epsilon
	)
	return inside and _hold_timer >= hold_settle_time


## TaskPatrol


func request_patrol(points: Array[Vector3], ping_pong: bool, loop_forever: bool = false) -> void:
	_holding = false
	_patrol_points = points.duplicate()
	_patrol_ping_pong = ping_pong
	_patrol_index = 0
	_patrol_forward = true
	_patrol_dwell = 0.0
	_patrol_loop_forever = loop_forever
	_moving = false
	# One single cycle then stop:
	# cycle: visit each point once (N segments)
	# ping-pong: go to end and back without repeating endpoints (2*N-2 segments)
	var n: int = _patrol_points.size()
	if n <= 1:
		_patrol_running = false
		return
	_patrol_segments_remaining = n if not ping_pong else max(2 * n - 2, 1)
	_patrol_running = true
	# Set first leg
	_move_target = _patrol_points[1]
	_moving = true
	_patrol_index = 1


func is_patrol_running() -> bool:
	return _patrol_running


## Optional setter to customize dwell time between patrol legs
func set_patrol_dwell(seconds: float) -> void:
	patrol_dwell_seconds = max(0.0, seconds)


# Initial helpers
func _step_move(dt: float) -> void:
	var speed: float = base_speed_mps * _speed_mult
	var pos: Vector3 = _actor.global_position
	var to_target: Vector3 = _move_target - pos
	var dist: float = to_target.length()

	if dist <= arrive_epsilon:
		_moving = false
		return

	var dir: Vector3 = to_target / max(dist, 0.0001)
	if rotate_to_velocity and dir.length() > 0.001:
		# Keep y up, rotate on horizontal plane
		var flat: Vector3 = Vector3(dir.x, 0.0, dir.z).normalized()
		if flat.length() > 0.001:
			_actor.look_at(_actor.global_position + flat, Vector3.UP)

	_actor.global_position = pos + dir * speed * dt


func _tick_hold(dt: float) -> void:
	if _actor == null:
		return
	var inside: bool = (
		_actor.global_position.distance_to(_hold_center) <= _hold_radius + arrive_epsilon
	)
	if inside and not _moving:
		_hold_timer += dt
	else:
		_hold_timer = 0.0


func _tick_patrol(dt: float) -> void:
	if not _moving:
		# dwell on point before next leg
		if _patrol_dwell < patrol_dwell_seconds:
			_patrol_dwell += dt
			return
		# advance to next patrol leg
		if _advance_patrol_leg():
			_patrol_dwell = 0.0
		else:
			# finished a single cycle
			if _patrol_loop_forever:
				# reset segments and continue
				var n: int = _patrol_points.size()
				_patrol_segments_remaining = n if not _patrol_ping_pong else max(2 * n - 2, 1)
				_patrol_forward = true
				_patrol_index = wrapi(_patrol_index, 0, max(n, 1))
				_patrol_dwell = 0.0
				# re-enter on next frame
				return
			_patrol_running = false
			return
	# move step
	_step_move(dt)
	# when a leg finishes, _moving becomes false and dwell begins next frame


func _advance_patrol_leg() -> bool:
	if _patrol_points.is_empty():
		return false
	if _patrol_segments_remaining <= 0:
		return false

	var n: int = _patrol_points.size()
	# Compute next index
	if _patrol_ping_pong:
		if _patrol_forward:
			if _patrol_index >= n - 1:
				_patrol_forward = false
				_patrol_index -= 1
			else:
				_patrol_index += 1
		else:
			if _patrol_index <= 0:
				_patrol_forward = true
				_patrol_index += 1
			else:
				_patrol_index -= 1
	else:
		_patrol_index = (_patrol_index + 1) % n

	_move_target = _patrol_points[_patrol_index]
	_moving = true
	_patrol_segments_remaining -= 1
	return true
