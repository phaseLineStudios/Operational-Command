extends Node
class_name PathGrid

## Grid weights + A* over TerrainData.
## Builds per-profile movement costs from surfaces + slope.

## What to visualize.
enum DebugLayer { NONE, WEIGHT, SLOPE, LINE_DIST, SOLIDS }

## Terrain source.
@export var data: TerrainData
## Cell size in meters (pathfinding resolution).
@export_range(5, 200, 5) var cell_size_m := 25
## Allow diagonal movement.
@export var allow_diagonals := true
## Extra preference for road-like brushes (<1 = prefer).
@export var road_bias_weight := 1.0
## If a brush multiplier for profile == 0 -> cell blocked.
@export var zero_multiplier_blocks := true

@export_group("Slope")
## Multiplier per 1.0 grade (rise/run). E.g. 0.5 -> +50% cost at 100% grade.
@export_range(0.0, 3.0, 0.05) var slope_multiplier_per_grade := 0.6
## Cells with grade >= this are blocked (e.g. cliff). 1.0 = 100% grade = 45°.
@export_range(0.0, 3.0, 0.05) var max_traversable_grade := 1.2

@export_group("Lines")
## Radius (m) around line features that applies line brush multipliers.
@export_range(0.0, 50.0, 1.0) var line_influence_radius_m := 6.0

@export_group("Debug")
## Enable developer drawing from an external CanvasItem
@export var debug_enabled := false
## Movement profile
@export var debug_profile: TerrainBrush.MoveProfile = TerrainBrush.MoveProfile.FOOT
## Which layer to draw
@export var debug_layer: DebugLayer = DebugLayer.WEIGHT
## Cell alpha for overlay
@export_range(0.0, 1.0, 0.05) var debug_alpha := 0.35
## Draw thin cell borders
@export var debug_cell_borders := true
## Clamp max heat color to this weight (for contrast)
@export var debug_weight_vis_max := 5.0

## Emitted when the grid is rebuilt.
signal grid_rebuilt
## Emits when an async build starts.
signal build_started(profile: int)
## Emits progress (0..1).
signal build_progress(p: float)
## Emits when a fresh grid is ready (and installed).
signal build_ready(profile: int)
## Emits on failure/cancel.
signal build_failed(reason: String)

var _astar := AStarGrid2D.new()
var _cols := 0
var _rows := 0

var _area_features: Array = []
var _line_features: Array = []

var _astar_cache: Dictionary = {}
var _slope_cache: Dictionary = {}
var _line_dist_cache: Dictionary = {}
var _terrain_epoch := 0
var _elev_epoch := 0
var _surfaces_epoch := 0
var _lines_epoch := 0

var _build_thread: Thread
var _build_cancel := false
var _build_running := false
var _build_profile := TerrainBrush.MoveProfile.FOOT


func _ready() -> void:
	astar_setup_defaults()
	_bind_terrain_signals()


func _exit_tree() -> void:
	if _build_running:
		_build_cancel = true
		await get_tree().process_frame
	if _build_thread:
		_build_thread.wait_to_finish()
		_build_thread = null


func astar_setup_defaults() -> void:
	_astar.diagonal_mode = (
		AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES if allow_diagonals else AStarGrid2D.DIAGONAL_MODE_NEVER
	)
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	_astar.jumping_enabled = false


func _bind_terrain_signals() -> void:
	if data == null:
		return
	data.changed.connect(func(): _terrain_epoch += 1)
	data.elevation_changed.connect(func(_r: Rect2i): _elev_epoch += 1)
	data.surfaces_changed.connect(func(_k: String, _ids: PackedInt32Array): _surfaces_epoch += 1)
	data.lines_changed.connect(func(_k: String, _ids: PackedInt32Array): _lines_epoch += 1)


## Build/rebuild grid for a movement profile
func rebuild(profile: int) -> void:
	if data == null:
		push_warning("PathGrid: no TerrainData.")
		return

	_collect_features()
	_cols = int(ceil(float(data.width_m) / cell_size_m))
	_rows = int(ceil(float(data.height_m) / cell_size_m))

	var key := _astar_key(profile)
	if _astar_cache.has(key):
		_astar = _astar_cache[key]
		emit_signal("grid_rebuilt")
		emit_signal("build_ready", profile)
		return

	_prepare_slope_cache()
	_prepare_line_dist_cache()

	if _build_running:
		_build_cancel = true
		await get_tree().process_frame

	var elev_img := data.elevation
	var elev_copy := Image.new()
	if elev_img and not elev_img.is_empty():
		elev_copy = elev_img.duplicate()

	var areas := []
	for it in _area_features:
		(
			areas
			. append(
				{
					"poly": it.poly,
					"mv":
					{
						"t": it.brush.mv_tracked,
						"w": it.brush.mv_wheeled,
						"f": it.brush.mv_foot,
						"r": it.brush.mv_riverine,
					},
					"z": it.brush.z_index
				}
			)
		)

	var lines := []
	for it in _line_features:
		(
			lines
			. append(
				{
					"pts": it.pts,
					"mv":
					{
						"t": it.brush.mv_tracked,
						"w": it.brush.mv_wheeled,
						"f": it.brush.mv_foot,
						"r": it.brush.mv_riverine,
					},
					"road_bias": it.brush.road_bias,
					"width_px": float(it.get("width_px", 0.0)),
					"aabb": it.aabb,
					"bridge_cap": float(it.brush.bridge_capacity_tons)
				}
			)
		)

	var snap := {
		"cols": _cols,
		"rows": _rows,
		"cell": float(cell_size_m),
		"base_elev": float(data.base_elevation_m),
		"areas": areas,
		"lines": lines,
		"line_r": float(line_influence_radius_m),
		"slopeK": float(slope_multiplier_per_grade),
		"maxGrade": float(max_traversable_grade),
		"allow_diag": bool(allow_diagonals),
		"profile": profile,
		"road_bias_weight": float(road_bias_weight),
		"zero_blocks": bool(zero_multiplier_blocks),
		"elev": elev_copy,
		"elev_res_m": int(data.elevation_resolution_m),
		"key": key,
	}

	_build_cancel = false
	_build_running = true
	_build_profile = profile as TerrainBrush.MoveProfile
	emit_signal("build_started", profile)

	if _build_thread:
		_build_thread.wait_to_finish()
		_build_thread = null
	_build_thread = Thread.new()
	_build_thread.start(Callable(self, "_thread_build").bind(snap), Thread.PRIORITY_LOW)


## Internal: worker function (runs off the main thread)
func _thread_build(snap: Dictionary) -> void:
	var cols := int(snap.cols)
	var rows := int(snap.rows)
	var cell := float(snap.cell)

	var weights := PackedFloat32Array()
	weights.resize(cols * rows)
	var solids := PackedByteArray()
	solids.resize(cols * rows)

	var elev_at_m = func(p: Vector2) -> float:
		var img: Image = snap.elev
		if img == null or img.is_empty():
			return float(snap.base_elev)
		var px := Vector2i(
			clampi(int(round(p.x / snap.elev_res_m)), 0, img.get_width() - 1),
			clampi(int(round(p.y / snap.elev_res_m)), 0, img.get_height() - 1)
		)
		return img.get_pixel(px.x, px.y).r + float(snap.base_elev)

	var slope_mult_at = func(cx: int, cy: int) -> float:
		var p := Vector2((cx + 0.5) * cell, (cy + 0.5) * cell)
		var sx := cell * 0.5
		var sy := cell * 0.5
		var e_l: float = elev_at_m.call(p - Vector2(sx, 0))
		var e_r: float = elev_at_m.call(p + Vector2(sx, 0))
		var e_u: float = elev_at_m.call(p - Vector2(0, sy))
		var e_d: float = elev_at_m.call(p + Vector2(0, sy))
		var dx: float = (e_r - e_l) / max(cell, 0.001)
		var dy: float = (e_d - e_u) / max(cell, 0.001)
		var grade := sqrt(dx * dx + dy * dy)
		if grade >= float(snap.maxGrade):
			return INF
		return 1.0 + float(snap.slopeK) * grade

	var mv_mult_area_at = func(p: Vector2) -> float:
		var best := 1.0
		var best_z := -INF
		for it in snap.areas:
			var aabb: Rect2 = _poly_bounds(it.poly)
			if not aabb.has_point(p):
				continue
			if Geometry2D.is_point_in_polygon(p, it.poly):
				var z := int(it.z)
				if z > best_z:
					best_z = z
					match int(snap.profile):
						TerrainBrush.MoveProfile.TRACKED:
							best = max(float(it.mv.t), 0.0)
						TerrainBrush.MoveProfile.WHEELED:
							best = max(float(it.mv.w), 0.0)
						TerrainBrush.MoveProfile.FOOT:
							best = max(float(it.mv.f), 0.0)
						TerrainBrush.MoveProfile.RIVERINE:
							best = max(float(it.mv.r), 0.0)
		return best

	var mv_mult_line_at = func(p: Vector2) -> Dictionary:
		var mult := 1.0
		var pref := 1.0
		var has_bridge := false
		var hit := false
		for it in snap.lines:
			var aabb: Rect2 = it.aabb
			if not aabb.has_point(p):
				continue
			var eff_r_m: float = float(snap.line_r) if float(snap.line_r) > 0.0 else max(0.0, float(it.width_px) * 0.5)
			var d := _dist_point_polyline(p, it.pts)
			if d <= eff_r_m:
				hit = true
				match int(snap.profile):
					TerrainBrush.MoveProfile.TRACKED:
						mult = min(mult, max(float(it.mv.t), 0.0))
					TerrainBrush.MoveProfile.WHEELED:
						mult = min(mult, max(float(it.mv.w), 0.0))
					TerrainBrush.MoveProfile.FOOT:
						mult = min(mult, max(float(it.mv.f), 0.0))
					TerrainBrush.MoveProfile.RIVERINE:
						mult = min(mult, max(float(it.mv.r), 0.0))
				pref = min(pref, max(0.05, float(it.road_bias)))
				if float(it.get("bridge_cap", 0.0)) > 0.0:
					has_bridge = true
		return {"m": mult, "pref": pref, "bridge": has_bridge, "hit": hit}

	for cy in rows:
		if _build_cancel:
			_call_main("_thread_finish", null, "cancelled")
			return
		for cx in cols:
			var idx := cy * cols + cx
			var pos := Vector2((cx + 0.5) * cell, (cy + 0.5) * cell)

			var area_m: float = mv_mult_area_at.call(pos)
			var line_res: Dictionary = mv_mult_line_at.call(pos)
			var slope_mult: float = slope_mult_at.call(cx, cy)
			var on_bridge := bool(line_res.bridge) and int(snap.profile) != TerrainBrush.MoveProfile.RIVERINE

			if not on_bridge and bool(snap.zero_blocks) and area_m <= 0.0:
				solids[idx] = 1
				weights[idx] = 1.0
				continue
			if slope_mult >= INF:
				solids[idx] = 1
				weights[idx] = 1.0
				continue

			var mv_mult: float = (
				float(line_res.m) if on_bridge else (min(area_m, float(line_res.m)) if bool(line_res.hit) else area_m)
			)
			var road_pref := mix(1.0, float(line_res.pref), clamp(float(snap.road_bias_weight), 0.0, 1.0))

			var w := mv_mult * slope_mult * road_pref
			if w >= 1e6:
				solids[idx] = 1
				weights[idx] = 1.0
			else:
				solids[idx] = 0
				weights[idx] = clamp(w, 0.001, 1e4)

		if cy % 8 == 0:
			_call_main("_emit_build_progress", float(cy) / float(rows))

	_call_main(
		"_thread_finish",
		{
			"weights": weights,
			"solids": solids,
			"profile": int(snap.profile),
			"cols": cols,
			"rows": rows,
			"key": String(snap.key),
		},
		""
	)


## Cancel an ongoing async build (best-effort)
func rebuild_async_cancel() -> void:
	if _build_running:
		_build_cancel = true


## Create A* on main thread, cache it, swap in, and emit signals.
func _thread_finish(result: Variant, err: String) -> void:
	_build_running = false
	if _build_thread:
		_build_thread.wait_to_finish()
		_build_thread = null

	if err != "":
		_emit_build_failed(err)
		return
	if result == null:
		_emit_build_failed("no result")
		return

	var cols := int(result.cols)
	var rows := int(result.rows)
	var g := AStarGrid2D.new()
	g.region = Rect2i(0, 0, cols, rows)
	g.cell_size = Vector2(cell_size_m, cell_size_m)
	g.diagonal_mode = (
		AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES if allow_diagonals else AStarGrid2D.DIAGONAL_MODE_NEVER
	)
	g.default_compute_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	g.default_estimate_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	g.jumping_enabled = false
	g.update()

	var weights: PackedFloat32Array = result.weights
	var solids: PackedByteArray = result.solids

	for cy in rows:
		for cx in cols:
			var id := Vector2i(cx, cy)
			var idx := cy * cols + cx
			g.set_point_solid(id, solids[idx] == 1)
			g.set_point_weight_scale(id, max(weights[idx], 0.001))

	var key := String(result.key)
	_astar_cache[key] = g
	_astar = g

	_emit_grid_rebuilt()
	_emit_build_ready(int(result.profile))


## Find a path (meters) for a profile. Returns PackedVector2Array world positions (m)
func find_path_m(start_m: Vector2, goal_m: Vector2) -> PackedVector2Array:
	var a := _to_cell(start_m)
	var b := _to_cell(goal_m)
	if not _in_bounds(a) or not _in_bounds(b):
		return PackedVector2Array()

	var cells := _astar.get_id_path(a, b)
	var out := PackedVector2Array()
	out.resize(cells.size())
	for i in cells.size():
		out[i] = _cell_center_m(cells[i])
	return out


## Estimate travel time (seconds) along path for unit base speed and profile
func estimate_travel_time_s(path_m: PackedVector2Array, base_speed_mps: float, _profile: int) -> float:
	if path_m.size() < 2 or base_speed_mps <= 0.0:
		return 0.0

	var t := 0.0
	for i in range(1, path_m.size()):
		var a := path_m[i - 1]
		var b := path_m[i]
		var d := a.distance_to(b)
		var mid := (a + b) * 0.5
		var cell := _to_cell(mid)
		if not _in_bounds(cell) or _astar.is_point_solid(cell):
			return INF
		var w := _astar.get_point_weight_scale(cell)
		var v: float = base_speed_mps / max(w, 0.001)
		t += d / max(v, 0.001)
	return t


## Create a stable cache key for A* instances (includes everything that changes weights)
func _astar_key(profile: int) -> String:
	return (
		(
			"%s|v=%d/%d/%d/%d|cell=%.1f|diag=%s|smax=%.3f|slopeK=%.3f|lineR=%.1f|roadBias=%.3f"
			% [
				str(data.get_instance_id()),
				_terrain_epoch,
				_elev_epoch,
				_surfaces_epoch,
				_lines_epoch,
				cell_size_m,
				str(allow_diagonals),
				max_traversable_grade,
				slope_multiplier_per_grade,
				line_influence_radius_m,
				road_bias_weight
			]
		)
		+ "|p=%d" % profile
	)


## Keys for intermediate rasters (don’t include profile so they can be reused)
func _raster_key(kind: String) -> String:
	return (
		"%s|%s|v=%d/%d/%d/%d|cell=%.1f"
		% [str(data.get_instance_id()), kind, _terrain_epoch, _elev_epoch, _surfaces_epoch, _lines_epoch, cell_size_m]
	)


## Convert world meters -> grid cell.
func world_to_cell(p_m: Vector2) -> Vector2i:
	return _to_cell(p_m)


## Convert grid cell -> world meters (cell center).
func cell_to_world_center_m(c: Vector2i) -> Vector2:
	return _cell_center_m(c)


func _weight_for_cell(cx: int, cy: int, profile: int, _r_solid: bool) -> float:
	var pos_m := _cell_center_m(Vector2i(cx, cy))
	var surface_mult := _surface_multiplier_at(pos_m, profile)

	var on_bridge := false
	var line_mult := 1.0
	var pref := 1.0
	var hit := false
	for it in _line_features:
		var aabb: Rect2 = it.aabb
		if not aabb.has_point(pos_m):
			continue
		var eff_r_m := (
			line_influence_radius_m if line_influence_radius_m > 0.0 else _line_px_to_meters(float(it.width_px)) * 0.5
		)
		var d := _dist_point_polyline(pos_m, it.pts)
		if d <= eff_r_m:
			hit = true
			if float(it.get("bridge_cap", 0.0)) > 0.0 and profile != TerrainBrush.MoveProfile.RIVERINE:
				on_bridge = true
			line_mult = min(line_mult, max(it.brush.movement_multiplier(profile), 0.0))
			pref = min(pref, max(0.05, it.brush.road_bias))

	if not on_bridge and zero_multiplier_blocks and surface_mult <= 0.0:
		_r_solid = true
		return 1.0

	var sl_key := _raster_key("slope")
	var slope_mult: float = (
		_slope_cache[sl_key][cy * _cols + cx] if _slope_cache.has(sl_key) else _slope_multiplier_at_cell(cx, cy)
	)
	if slope_mult >= INF:
		_r_solid = true
		return 1.0

	var mv_mult: float = line_mult if on_bridge else (min(surface_mult, line_mult) if hit else surface_mult)
	var road_pref := mix(1.0, pref, clamp(road_bias_weight, 0.0, 1.0))
	var w := mv_mult * slope_mult * road_pref * road_pref
	if w >= 1e6:
		_r_solid = true
		return 1.0
	return clamp(w, 0.001, 1e4)


## Build or reuse the slope “multiplier” raster (profile-agnostic)
func _prepare_slope_cache() -> void:
	var key := _raster_key("slope")
	if _slope_cache.has(key):
		return
	var arr := PackedFloat32Array()
	arr.resize(_cols * _rows)
	for cy in _rows:
		for cx in _cols:
			arr[cy * _cols + cx] = _slope_multiplier_at_cell(cx, cy)
	_slope_cache[key] = arr


## distance-to-nearest-line cache (profile-agnostic)
func _prepare_line_dist_cache() -> void:
	var key := _raster_key("line")
	if _line_dist_cache.has(key):
		return
	if _line_features.is_empty():
		_line_dist_cache.erase(key)
		return

	var arr := PackedFloat32Array()
	arr.resize(_cols * _rows)
	for cy in _rows:
		for cx in _cols:
			var p := _cell_center_m(Vector2i(cx, cy))
			var best := INF
			for it in _line_features:
				if not it.aabb.has_point(p):
					continue
				best = min(best, _dist_point_polyline(p, it.pts))
			arr[cy * _cols + cx] = best
	_line_dist_cache[key] = arr


func _surface_multiplier_at(p_m: Vector2, profile: int) -> float:
	var best_mult := 1.0
	var best_z := -INF
	for it in _area_features:
		var aabb: Rect2 = it.aabb
		if not aabb.has_point(p_m):
			continue
		if Geometry2D.is_point_in_polygon(p_m, it.poly):
			var brush: TerrainBrush = it.brush
			var z := brush.z_index
			if z > best_z:
				best_z = z
				best_mult = max(brush.movement_multiplier(profile), 0.0)
	return best_mult


func _line_px_to_meters(width_px: float) -> float:
	return max(0.0, width_px)


func _line_multiplier_at(p_m: Vector2, profile: int) -> float:
	var out := 1.0
	for it in _line_features:
		var aabb: Rect2 = it.aabb
		if not aabb.has_point(p_m):
			continue
		var eff_r_m := line_influence_radius_m
		if eff_r_m <= 0.0:
			eff_r_m = _line_px_to_meters(float(it.width_px)) * 0.5
		var d := _dist_point_polyline(p_m, it.pts)
		if d <= eff_r_m:
			var m: float = max(it.brush.movement_multiplier(profile), 0.0)
			out = min(out, m)
	return out


func _road_bias_at(p_m: Vector2) -> float:
	var pref := 1.0
	for it in _line_features:
		if it.brush.road_bias < 1.0:
			var aabb: Rect2 = it.aabb
			if aabb.has_point(p_m):
				var d := _dist_point_polyline(p_m, it.pts)
				if d <= line_influence_radius_m:
					pref = min(pref, max(0.05, it.brush.road_bias))
	return pref


func _slope_multiplier_at_cell(cx: int, cy: int) -> float:
	if data == null or data.elevation == null or data.elevation.is_empty():
		return 1.0
	var p := _cell_center_m(Vector2i(cx, cy))

	var sx := cell_size_m * 0.5
	var sy := cell_size_m * 0.5
	var e_r := _elev_m_at(p + Vector2(sx, 0.0))
	var e_l := _elev_m_at(p - Vector2(sx, 0.0))
	var e_u := _elev_m_at(p - Vector2(0.0, sy))
	var e_d := _elev_m_at(p + Vector2(0.0, sy))

	var dx: float = (e_r - e_l) / max(cell_size_m, 0.001)
	var dy: float = (e_d - e_u) / max(cell_size_m, 0.001)
	var grade := sqrt(dx * dx + dy * dy)

	if grade >= max_traversable_grade:
		return INF
	return 1.0 + slope_multiplier_per_grade * grade


func _collect_features() -> void:
	_area_features.clear()
	_line_features.clear()
	if data == null:
		return

	for s in data.surfaces:
		if typeof(s) != TYPE_DICTIONARY:
			continue
		var brush: TerrainBrush = s.get("brush", null)
		if brush == null:
			continue
		var pts: PackedVector2Array = s.get("points", PackedVector2Array())
		if pts.size() < 3:
			continue
		if bool(s.get("closed", true)) and pts.size() >= 2 and pts[0].distance_squared_to(pts[pts.size() - 1]) < 1e-9:
			var tmp := PackedVector2Array(pts)
			tmp.remove_at(tmp.size() - 1)
			pts = tmp
			if pts.size() < 3:
				continue
		var poly := pts
		var aabb := _poly_bounds(poly)
		_area_features.append({"poly": poly, "brush": brush, "aabb": aabb})

	for l in data.lines:
		if typeof(l) != TYPE_DICTIONARY:
			continue
		var brush: TerrainBrush = l.get("brush", null)
		if brush == null:
			continue
		var pts: PackedVector2Array = l.get("points", PackedVector2Array())
		if pts.size() < 2:
			continue
		var aabb := _polyline_bounds(pts)
		aabb = aabb.grow(max(line_influence_radius_m, _line_px_to_meters(l.get("width_px", 0.0)) * 0.5))
		_line_features.append(
			{
				"pts": pts,
				"brush": brush,
				"aabb": aabb,
				"width_px": float(l.get("width_px", 0.0)),
				"bridge_cap": float(brush.bridge_capacity_tons)
			}
		)


func _to_cell(p_m: Vector2) -> Vector2i:
	var cx: int = clamp(int(floor(p_m.x / cell_size_m)), 0, _cols - 1)
	var cy: int = clamp(int(floor(p_m.y / cell_size_m)), 0, _rows - 1)
	return Vector2i(cx, cy)


func _cell_center_m(c: Vector2i) -> Vector2:
	return Vector2((c.x + 0.5) * cell_size_m, (c.y + 0.5) * cell_size_m)


func _in_bounds(c: Vector2i) -> bool:
	return c.x >= 0 and c.y >= 0 and c.x < _cols and c.y < _rows


func _elev_m_at(p_m: Vector2) -> float:
	var px := data.world_to_elev_px(p_m)
	return data.get_elev_px(px) + float(data.base_elevation_m)


## Return grid cell for world meters.
func debug_cell_from_world(p_m: Vector2) -> Vector2i:
	return _to_cell(p_m)


## Return cell center in meters.
func debug_world_from_cell(c: Vector2i) -> Vector2:
	return _cell_center_m(c)


## Weight at cell (or INF if OOB/solid).
func debug_weight_at_cell(c: Vector2i) -> float:
	if _astar == null or not _astar.is_in_boundsv(c):
		return INF
	if _astar.is_point_solid(c):
		return INF
	return _astar.get_point_weight_scale(c)


## True if solid.
func debug_is_solid_cell(c: Vector2i) -> bool:
	return _astar != null and _astar.is_in_boundsv(c) and _astar.is_point_solid(c)


## Slope multiplier at cell (uses cache if present).
func debug_slope_mult_cell(c: Vector2i) -> float:
	var key := _raster_key("slope")
	if _slope_cache.has(key):
		return _slope_cache[key][c.y * _cols + c.x]
	return _slope_multiplier_at_cell(c.x, c.y)


## Distance to nearest line at cell (uses cache if present; INF if none).
func debug_line_dist_cell(c: Vector2i) -> float:
	var key := _raster_key("line")
	if _line_dist_cache.has(key) and _line_dist_cache[key].size() > 0:
		return _line_dist_cache[key][c.y * _cols + c.x]
	var p := _cell_center_m(c)
	var best := INF
	for it in _line_features:
		if not it.aabb.has_point(p):
			continue
		best = min(best, _dist_point_polyline(p, it.pts))
	return best


## Render a grid overlay onto a CanvasItem (e.g., a Control). Coordinates are meters.
func debug_draw_overlay(ci: CanvasItem) -> void:
	if not debug_enabled or ci == null or _astar == null:
		return

	var region := _astar.region
	if region.size.x <= 0 or region.size.y <= 0:
		return

	var cs := cell_size_m
	var terrain_rect := Rect2(Vector2.ZERO, Vector2(region.size.x * cs, region.size.y * cs))
	var draw_rect := terrain_rect

	var x0: float = max(region.position.x, int(floor(draw_rect.position.x / cs)))
	var y0: float = max(region.position.y, int(floor(draw_rect.position.y / cs)))
	var x1: float = min(
		region.position.x + region.size.x - 1, int(floor((draw_rect.position.x + draw_rect.size.x - 0.0001) / cs))
	)
	var y1: float = min(
		region.position.y + region.size.y - 1, int(floor((draw_rect.position.y + draw_rect.size.y - 0.0001) / cs))
	)
	if x1 < x0 or y1 < y0:
		return

	for cy in range(y0, y1 + 1):
		for cx in range(x0, x1 + 1):
			var cell := Vector2i(cx, cy)
			if not _astar.is_in_boundsv(cell):
				continue

			var cell_rect := Rect2(Vector2(cx * cs, cy * cs), Vector2(cs, cs))
			var col := Color.TRANSPARENT

			match debug_layer:
				DebugLayer.SOLIDS:
					if _astar.is_point_solid(cell):
						col = Color(0.9, 0.2, 0.2, debug_alpha)

				DebugLayer.WEIGHT:
					if _astar.is_point_solid(cell):
						col = Color(0.9, 0.2, 0.2, debug_alpha)
					else:
						var w := _astar.get_point_weight_scale(cell)
						var t: float = clamp(w / max(0.001, debug_weight_vis_max), 0.0, 1.0)
						col = Color(t, t, 0.0, debug_alpha).lerp(Color(1, 0, 0, debug_alpha), t)

				DebugLayer.SLOPE:
					var s := debug_slope_mult_cell(cell)
					var t2: float = clamp((s - 1.0) / max(0.001, debug_weight_vis_max), 0.0, 1.0)
					col = Color(0.0, 0.4 + 0.6 * t2, 1.0, debug_alpha)

				DebugLayer.LINE_DIST:
					var d := debug_line_dist_cell(cell)
					if d < INF:
						var t3: float = clamp(1.0 - (d / max(1.0, line_influence_radius_m)), 0.0, 1.0)
						col = Color(1.0, 1.0 - t3, 0.0, debug_alpha)

			if col.a > 0.0:
				ci.draw_rect(cell_rect, col, true)
			if debug_cell_borders:
				ci.draw_rect(cell_rect, Color(0, 0, 0, 0.1), false)


func _call_main(method: String, a0: Variant = null, a1: Variant = null) -> void:
	if a0 == null and a1 == null:
		call_deferred(method)
	elif a0 != null and a1 == null:
		call_deferred(method, a0)
	elif a0 != null and a1 != null:
		call_deferred(method, a0, a1)


func _emit_build_started(profile: int) -> void:
	emit_signal("build_started", profile)


func _emit_build_progress(p: float) -> void:
	emit_signal("build_progress", p)


func _emit_grid_rebuilt() -> void:
	emit_signal("grid_rebuilt")


func _emit_build_ready(profile: int) -> void:
	emit_signal("build_ready", profile)


func _emit_build_failed(reason: String) -> void:
	emit_signal("build_failed", reason)


static func _closed_no_dup(pts: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array(pts)
	if out.size() >= 2 and out[0].distance_squared_to(out[out.size() - 1]) < 1e-9:
		out.remove_at(out.size() - 1)
	return out


static func _poly_bounds(poly: PackedVector2Array) -> Rect2:
	var r := Rect2(poly[0], Vector2.ZERO)
	for i in range(1, poly.size()):
		r = r.expand(poly[i])
	return r


static func _polyline_bounds(pts: PackedVector2Array) -> Rect2:
	var r := Rect2(pts[0], Vector2.ZERO)
	for i in range(1, pts.size()):
		r = r.expand(pts[i])
	return r


static func _dist_point_polyline(p: Vector2, pts: PackedVector2Array) -> float:
	var best := INF
	for i in range(1, pts.size()):
		best = min(best, Geometry2D.get_closest_point_to_segment(p, pts[i - 1], pts[i]).distance_to(p))
	return best


static func mix(a: float, b: float, t: float) -> float:
	return a * (1.0 - t) + b * t
