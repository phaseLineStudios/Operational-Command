# ContourLayer.gd (runtime, for your in-game TerrainEditor too)
extends Control
class_name ContourLayer

# ---- Style knobs (same names as in TerrainRender) ----
@export var contour_color: Color = Color(0.15, 0.15, 0.15, 0.7)
@export var contour_thick_color: Color = Color(0.1, 0.1, 0.1, 0.85)
@export var contour_px: float = 1.0
@export var contour_thick_every_m: int = 50
@export var antialias: bool = true

# ---- Data ----
var data: TerrainData
var _data_conn := false
var _data_conn_elev := false

# ---- Cache ----
var _levels: PackedFloat32Array = []
var _polylines_by_level: Dictionary = {}  # level(float) -> Array[PackedVector2Array]
var _dirty := true

# ---- Debounce for live editing ----
var _rebuild_scheduled := false
@export var rebuild_delay_sec := 0.05  # tune for your editor feel

# ------------------ Public API ------------------

func set_data(d: TerrainData) -> void:
	# disconnect old
	if _data_conn and data and data.is_connected("changed", Callable(self, "_on_data_changed")):
		data.disconnect("changed", Callable(self, "_on_data_changed"))
	if _data_conn_elev and data and data.has_signal("elevation_changed") and data.is_connected("elevation_changed", Callable(self, "_on_elevation_changed")):
		data.disconnect("elevation_changed", Callable(self, "_on_elevation_changed"))
	_data_conn = false
	_data_conn_elev = false

	data = d
	_mark_dirty()

	# connect new (runtime)
	if data:
		data.changed.connect(_on_data_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED)
		_data_conn = true
		# Optional: if you add a more granular signal on your TerrainData later:
		if data.has_signal("elevation_changed"):
			data.elevation_changed.connect(_on_elevation_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED)
			_data_conn_elev = true

	_schedule_rebuild()  # initial build
	queue_redraw()

# Optional convenience if you want to push style from TerrainRender in one call
func apply_style(from: Node) -> void:
	if from == null: return
	if "contour_color" in from: contour_color = from.contour_color
	if "contour_thick_color" in from: contour_thick_color = from.contour_thick_color
	if "contour_px" in from: contour_px = from.contour_px
	if "contour_thick_every_m" in from: contour_thick_every_m = from.contour_thick_every_m
	_mark_dirty()
	_schedule_rebuild()

# Call this from your TerrainEditor after a paint pass (or per stroke)
func request_rebuild() -> void:
	_mark_dirty()
	_schedule_rebuild()

# ------------------ Notifications ------------------

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		# size changed; geometry is in world units, just redraw
		queue_redraw()

# ------------------ Live update plumbing ------------------

func _on_data_changed() -> void:
	_mark_dirty()
	_schedule_rebuild()

# If you add TerrainData.elevation_changed(rect2i), we can still full rebuild for now.
# You can later extend this to do partial rebuilds.
func _on_elevation_changed(_rect := Rect2i(0,0,0,0)) -> void:
	_mark_dirty()
	_schedule_rebuild()

func _mark_dirty() -> void:
	_dirty = true

func _schedule_rebuild() -> void:
	if _rebuild_scheduled:
		return
	_rebuild_scheduled = true
	var t := get_tree().create_timer(rebuild_delay_sec)
	t.timeout.connect(func ():
		_rebuild_scheduled = false
		if not is_instance_valid(self): return
		_rebuild_contours()
		queue_redraw()
	)

# ------------------ Drawing ------------------

func _draw() -> void:
	if data == null:
		return
	# If something marked dirty but no timer is running (e.g., first draw), rebuild now.
	if _dirty and not _rebuild_scheduled:
		_rebuild_contours()

	for i in _levels.size():
		var level := _levels[i]
		var polylines: Array = _polylines_by_level.get(level, [])
		if polylines.is_empty():
			continue

		var thick := (contour_thick_every_m > 0) and _is_multiple(level, float(contour_thick_every_m))
		var col := contour_thick_color if thick else contour_color
		var w: float = max(0.5, (contour_px * 1.6) if thick else contour_px)

		for line: PackedVector2Array in polylines:
			if line.size() >= 2:
				draw_polyline(line, col, w, antialias)

# ------------------ Geometry build ------------------

func _rebuild_contours() -> void:
	_dirty = false
	_polylines_by_level.clear()
	_levels.clear()

	if data == null or data.elevation == null or data.elevation.is_empty():
		return

	var img: Image = data.elevation

	var w := img.get_width()
	var h := img.get_height()
	if w < 2 or h < 2:
		return

	var step_m := float(max(1, data.elevation_resolution_m))
	var dH := float(max(1, data.contour_interval_m))

	# scan elevation range
	var min_e := INF
	var max_e := -INF
	for y in h:
		for x in w:
			var e := img.get_pixel(x, y).r
			if e < min_e: min_e = e
			if e > max_e: max_e = e

	# choose contour levels
	var start_level: float = floor(min_e / dH) * dH
	var level := start_level
	while level <= max_e + 0.0001:
		_levels.append(level)
		level += dH

	# build segments per level and stitch to polylines
	for L in _levels:
		var segments := _march_level_segments(img, w, h, step_m, L)
		var polylines := _stitch_segments_to_polylines(segments)
		_polylines_by_level[L] = polylines

# marching squares per level -> segments
func _march_level_segments(img: Image, w: int, h: int, step_m: float, level: float) -> Array:
	var segs: Array = []   # Array[PackedVector2Array]

	for j in range(0, h - 1):
		for i in range(0, w - 1):
			var zTL := img.get_pixel(i,     j    ).r
			var zTR := img.get_pixel(i + 1, j    ).r
			var zBR := img.get_pixel(i + 1, j + 1).r
			var zBL := img.get_pixel(i,     j + 1).r

			var x0 := i * step_m
			var y0 := j * step_m
			var x1 := (i + 1) * step_m
			var y1 := (j + 1) * step_m

			var c := 0
			if zTL > level: c |= 1
			if zTR > level: c |= 2
			if zBR > level: c |= 4
			if zBL > level: c |= 8
			if c == 0 or c == 15:
				continue

			var lerp_t = func (a: float, b: float) -> float:
				var denom := (b - a)
				return 0.5 if abs(denom) < 1e-6 else clamp((level - a) / denom, 0.0, 1.0)

			var pts := {}  # edge -> Vector2

			# Edges: 0=top,1=right,2=bottom,3=left
			# Crossings exist when edge vertices straddle the level
			if ( (c & 1) != (c & 2) ):
				var t0: float = lerp_t.call(zTL, zTR)
				pts[0] = Vector2(lerp(x0, x1, t0), y0)
			if ( (c & 2) != (c & 4) ):
				var t1: float = lerp_t.call(zTR, zBR)
				pts[1] = Vector2(x1, lerp(y0, y1, t1))
			if ( (c & 4) != (c & 8) ):
				var t2: float = lerp_t.call(zBR, zBL)
				pts[2] = Vector2(lerp(x1, x0, t2), y1)
			if ( (c & 8) != (c & 1) ):
				var t3: float = lerp_t.call(zBL, zTL)
				pts[3] = Vector2(x0, lerp(y1, y0, t3))

			match c:
				1, 14:
					segs.append(PackedVector2Array([pts[3], pts[0]]))
				2, 13:
					segs.append(PackedVector2Array([pts[0], pts[1]]))
				4, 11:
					segs.append(PackedVector2Array([pts[1], pts[2]]))
				8, 7:
					segs.append(PackedVector2Array([pts[2], pts[3]]))
				3, 12:
					segs.append(PackedVector2Array([pts[3], pts[1]]))
				6, 9:
					segs.append(PackedVector2Array([pts[0], pts[2]]))
				5, 10:
					# Saddle: asymptotic decider via bilinear center
					var zC := (zTL + zTR + zBR + zBL) * 0.25
					if zC > level:
						segs.append(PackedVector2Array([pts[0], pts[1]]))
						segs.append(PackedVector2Array([pts[2], pts[3]]))
					else:
						segs.append(PackedVector2Array([pts[3], pts[0]]))
						segs.append(PackedVector2Array([pts[1], pts[2]]))
				_:
					pass

	return segs

# connect segments into polylines (open/closed)
func _stitch_segments_to_polylines(segments: Array) -> Array:
	var polylines: Array = []
	if segments.is_empty():
		return polylines

	var eps := 0.001
	var key = func (p: Vector2) -> Vector2:
		return Vector2(round(p.x / eps) * eps, round(p.y / eps) * eps)

	var start_map: Dictionary = {}
	var end_map: Dictionary = {}

	for seg: PackedVector2Array in segments:
		var a := seg[0]
		var b := seg[1]
		var ka: Vector2 = key.call(a)
		var kb: Vector2 = key.call(b)

		var attached := false

		if end_map.has(ka):
			var idx: int = end_map[ka][0]
			var poly: PackedVector2Array = polylines[idx]
			poly.append(b)
			end_map.erase(ka)
			end_map[key.call(b)] = [idx, true]
			attached = true
		elif start_map.has(kb):
			var idx2: int = start_map[kb][0]
			var poly2: PackedVector2Array = polylines[idx2]
			poly2.insert(0, a)
			start_map.erase(kb)
			start_map[key.call(a)] = [idx2, true]
			attached = true
		elif start_map.has(ka):
			var idx3: int = start_map[ka][0]
			var poly3: PackedVector2Array = polylines[idx3]
			poly3.insert(0, b)
			start_map.erase(ka)
			start_map[key.call(b)] = [idx3, true]
			attached = true
		elif end_map.has(kb):
			var idx4: int = end_map[kb][0]
			var poly4: PackedVector2Array = polylines[idx4]
			poly4.append(a)
			end_map.erase(kb)
			end_map[key.call(a)] = [idx4, true]
			attached = true

		if not attached:
			var pl := PackedVector2Array([a, b])
			var id := polylines.size()
			polylines.append(pl)
			start_map[key.call(a)] = [id, true]
			end_map[key.call(b)] = [id, true]

	return polylines

static func _is_multiple(value: float, step: float) -> bool:
	if step <= 0.0: return false
	var t := value / step
	return abs(t - round(t)) < 1e-4
