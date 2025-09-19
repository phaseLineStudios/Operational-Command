extends Node2D
class_name MovementAgent

## Moves this node over PathGrid in world meters.
## Uses base speed modified by PathGrid cell weight and terrain lines/areas.

## Pathfinding grid (provide in inspector or at runtime).
@export var grid: PathGrid
## Movement profile used for costs.
@export var profile: TerrainBrush.MoveProfile = TerrainBrush.MoveProfile.TRACKED
## Base speed in meters/second (before terrain modifiers).
@export var base_speed_kph: float = 8.0
## Distance to consider a waypoint reached (meters).
@export var arrival_threshold_m: float = 1.0
## If true, agent waits for grid build_ready before pathing.
@export var wait_for_grid_ready := true
## Virtual position in terrain meters
@export var sim_pos_m: Vector2 = Vector2.ZERO

@export_group("Debug")
## Master switch for all debug drawing.
@export var debug_draw := false
## Show a small text HUD with speed/ETA/weight.
@export var debug_show_hud := false
## Outline the current and next grid cells.
@export var debug_show_cells := false
## Draw the planned path and waypoint markers.
@export var debug_show_path := false
## Draw heading and per-frame velocity vectors.
@export var debug_show_vectors := false
## Keep a breadcrumb trail of recent positions.
@export var debug_trail_len := 64
## Radius (meters) for point markers.
@export var debug_marker_r_m := 2.5

var renderer: TerrainRender = null

## Emitted when the agent starts following a path.
signal movement_started()
## Emitted when the agent arrives at its final waypoint.
signal movement_arrived()
## Emitted if the agent cannot find a path or hits a blocked cell.
signal movement_blocked(reason: String)
## Emitted whenever a new path is set.
signal path_updated(path: PackedVector2Array)

var _path: PackedVector2Array = []
var _path_idx := 0
var _moving := false
var _trail: PackedVector2Array = []

func _ready() -> void:
	if grid and wait_for_grid_ready:
		grid.build_ready.connect(_on_grid_ready)
		grid.grid_rebuilt.connect(func(): _on_grid_ready(grid._build_profile))

func _physics_process(delta: float) -> void:
	if not _moving or _path.size() == 0:
		return

	_path_idx = clamp(_path_idx, 0, _path.size() - 1)

	var target := _path[_path_idx]
	var to_wp := target - sim_pos_m
	var dist := to_wp.length()

	if dist <= arrival_threshold_m:
		if _path_idx >= _path.size() - 1:
			_moving = false
			emit_signal("movement_arrived")
			return
		_path_idx += 1
		return

	var speed := _effective_speed_at(sim_pos_m)
	if speed <= 0.001:
		_moving = false
		emit_signal("movement_blocked", "blocked-cell")
		return

	var step: float = min(dist, speed * delta)
	var dir: Vector2 = (to_wp / max(dist, 0.001))
	sim_pos_m += dir * step
	rotation = dir.angle()
	
	if debug_draw:
		_debug_push_trail()
		queue_redraw()

func _effective_speed_at(p_m: Vector2) -> float:
	if not grid:
		return base_speed_kph
	var cell := grid.world_to_cell(p_m)
	if not grid._in_bounds(cell):
		return base_speed_kph
	if grid._astar and grid._astar.is_in_boundsv(cell) and grid._astar.is_point_solid(cell):
		return 0.0
	var w := 1.0
	if grid._astar and grid._astar.is_in_boundsv(cell):
		w = max(grid._astar.get_point_weight_scale(cell), 0.001)
	return base_speed_kph / w

## Command pathfind and start moving to a world-meter destination.
func move_to_m(dest_m: Vector2) -> void:
	if not grid:
		emit_signal("movement_blocked", "no-grid")
		return
	var path := grid.find_path_m(sim_pos_m, dest_m)
	if path.is_empty():
		_moving = false
		emit_signal("movement_blocked", "no-path")
		return
	_set_path(path)

## Command stop immediately.
func stop() -> void:
	_moving = false
	_path = []
	_path_idx = 0

## ETA (seconds) along current remaining path with current base speed.
func eta_seconds() -> float:
	if not grid or _path.size() <= 1 or not _moving:
		return 0.0
	var rem := PackedVector2Array()
	for i in range(_path_idx, _path.size()):
		rem.append(_path[i])
	return grid.estimate_travel_time_s(rem, base_speed_kph, profile)

func _set_path(p: PackedVector2Array) -> void:
	_path = p
	_path_idx = 0
	_moving = true
	emit_signal("path_updated", _path)
	emit_signal("movement_started")

func _on_grid_ready(ready_profile: int) -> void:
	if ready_profile == profile and _moving == false and _path.size() > 0:
		pass

## Push current position into the breadcrumb list.
func _debug_push_trail() -> void:
	if debug_trail_len <= 0: return
	var here_m := sim_pos_m
	_trail.append(here_m)
	if _trail.size() > debug_trail_len:
		_trail.remove_at(0)

## Get the agent's current cell (if grid exists).
func _debug_current_cell() -> Vector2i:
	if grid == null:
		return Vector2i(-1, -1)
	return grid.world_to_cell(sim_pos_m)

## Get a Rect2 (in *world meters*) for a cell id.
func _debug_cell_rect_world(c: Vector2i) -> Rect2:
	if grid == null or c.x < 0:
		return Rect2()
	var cs := grid.cell_size_m
	return Rect2(Vector2(c.x * cs, c.y * cs), Vector2(cs, cs))

## Read current cell weight safely.
func _debug_weight_here() -> float:
	if grid == null or grid._astar == null:
		return 1.0
	var c := _debug_current_cell()
	if not grid._in_bounds(c) or not grid._astar.is_in_boundsv(c):
		return 1.0
	if grid._astar.is_point_solid(c):
		return INF
	return max(grid._astar.get_point_weight_scale(c), 0.001)

## Compute instantaneous speed (m/s) based on last trail step.
func _debug_instant_speed(delta: float) -> float:
	if delta <= 0.0 or _trail.size() < 2:
		return 0.0
	var a := _trail[_trail.size() - 2]
	var b := _trail[_trail.size() - 1]
	return a.distance_to(b) / delta

func _draw() -> void:
	if not debug_draw:
		return

	if debug_show_path and _path.size() >= 2:
		for i in range(1, _path.size()):
			var a := _to_local_from_terrain(_path[i-1])
			var b := _to_local_from_terrain(_path[i])
			draw_line(a, b, Color(0.08, 0.08, 0.08, 1), 1.5)
			draw_circle(b, debug_marker_r_m, Color(0.0, 0.7, 0.0, 0.9))
		if _path_idx < _path.size():
			draw_circle(_to_local_from_terrain(_path[_path_idx]), debug_marker_r_m, Color(1.0, 0.45, 0.1, 0.9))

	if debug_show_cells and grid:
		var cur := grid.world_to_cell(sim_pos_m)
		if grid._in_bounds(cur):
			_draw_cell_rect_m(Rect2(Vector2(cur.x, cur.y) * grid.cell_size_m, Vector2.ONE * grid.cell_size_m),
				Color(0.15, 0.55, 1.0, 0.35), 2.0, false)
		if _path_idx < _path.size():
			var nxt := grid.world_to_cell(_path[_path_idx])
			if grid._in_bounds(nxt):
				_draw_cell_rect_m(Rect2(Vector2(nxt.x, nxt.y) * grid.cell_size_m, Vector2.ONE * grid.cell_size_m),
					Color(1.0, 0.4, 0.1, 0.35), 2.0, false)

	if debug_show_vectors:
		var base_m := sim_pos_m
		var heading := Vector2.RIGHT.rotated(rotation) * (debug_marker_r_m * 3.0)
		draw_line(_to_local_from_terrain(base_m),
				  _to_local_from_terrain(base_m + heading),
				  Color(0.2, 0.6, 1.0, 0.8), 2.0)
		if _trail.size() >= 2:
			var v: Vector2 = (_trail[_trail.size()-1] - _trail[_trail.size()-2]).limit_length(debug_marker_r_m * 4.0)
			draw_line(_to_local_from_terrain(base_m),
					  _to_local_from_terrain(base_m + v),
					  Color(0.2, 1.0, 0.2, 0.8), 2.0)

	if _trail.size() >= 2:
		for i in range(1, _trail.size()):
			draw_line(_to_local_from_terrain(_trail[i-1]), _to_local_from_terrain(_trail[i]),
				Color(0.0, 0.0, 0.0, 0.25), 1.0)

	if debug_show_hud:
		var hud_anchor_m := sim_pos_m
		var hud_local := _to_local_from_terrain(hud_anchor_m) + Vector2(8, -12)

		var font := ThemeDB.fallback_font
		var fsize := ThemeDB.fallback_font_size
		var w := _debug_weight_here()
		var eta := eta_seconds()
		var inst_v := _debug_instant_speed(get_process_delta_time())
		var txt := "w=%.2f  v=%.1f/%.1f m/s  ETA=%.1fs  idx:%d/%d" % [
			(w if w < INF else -1.0),
			inst_v,
			base_speed_kph / (w if w < INF else 1.0),
			eta,
			_path_idx, _path.size()
		]

		draw_set_transform(hud_local, -rotation, Vector2.ONE)
		draw_string(font, Vector2(1,1), txt, HORIZONTAL_ALIGNMENT_LEFT, -1.0, fsize, Color(0,0,0,0.8))
		draw_string(font, Vector2.ZERO, txt, HORIZONTAL_ALIGNMENT_LEFT, -1.0, fsize, Color(1,1,1,0.95))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw_cell_rect_m(rm: Rect2, col: Color, width: float, filled := false) -> void:
	var p0 := _to_local_from_terrain(rm.position)
	var p1 := _to_local_from_terrain(rm.position + Vector2(rm.size.x, 0))
	var p2 := _to_local_from_terrain(rm.position + rm.size)
	var p3 := _to_local_from_terrain(rm.position + Vector2(0, rm.size.y))
	if filled:
		draw_colored_polygon(PackedVector2Array([p0,p1,p2,p3]), col)
	else:
		draw_line(p0, p1, col, width); draw_line(p1, p2, col, width)
		draw_line(p2, p3, col, width); draw_line(p3, p0, col, width)

## Convert terrain meters -> this node's local draw space
func _to_local_from_terrain(p_m: Vector2) -> Vector2:
	if renderer == null:
		return to_local(p_m)
	var screen := renderer.terrain_to_map(p_m)
	return to_local(screen)
