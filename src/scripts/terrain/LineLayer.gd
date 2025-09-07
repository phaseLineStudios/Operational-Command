extends Control
class_name LineLayer

## Antialiasing for draw_polyline/draw_line.
@export var antialias: bool = true
## Snap odd-pixel strokes by offsetting geometry by (0.5, 0.5).
@export var snap_half_px_for_thin_strokes := true

@onready var renderer: TerrainRender = get_owner()

var data: TerrainData
var _data_conn := false

var _items: Dictionary = {}
var _strokes_dirty := true
var _strokes: Array = []

## Assigns TerrainData, resets caches, wires signals, and schedules redraw
func set_data(d: TerrainData) -> void:
	if _data_conn and data and data.is_connected("lines_changed", Callable(self, "_on_lines_changed")):
		data.disconnect("lines_changed", Callable(self, "_on_lines_changed"))
		_data_conn = false
	data = d
	_items.clear()
	_strokes.clear()
	_strokes_dirty = true
	if data:
		data.lines_changed.connect(_on_lines_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED)
		_data_conn = true
	queue_redraw()

## Marks the whole layer as dirty and queues a redraw (forces full rebuild)
func mark_dirty() -> void:
	_items.clear()
	_strokes.clear()
	_strokes_dirty = true
	queue_redraw()

## Handles TerrainData line mutations and marks affected lines dirty
func _on_lines_changed(kind: String, ids: PackedInt32Array) -> void:
	match kind:
		"reset":
			_items.clear()
			_strokes_dirty = true
		"added":
			for id in ids:
				_upsert_from_data(id, true)
		"removed":
			for id in ids:
				_items.erase(id)
			_strokes_dirty = true
		"points":
			for id in ids:
				_refresh_geometry(id)
		"style", "brush", "meta":
			for id in ids:
				_refresh_recipe_and_geometry(id)
		_:
			_items.clear()
			_strokes_dirty = true
	queue_redraw()

## Redraw on resize so strokes match current Control rect.
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_redraw()

func _draw() -> void:
	if data == null:
		return
	if _items.is_empty() and data.lines and not data.lines.is_empty():
		for s in data.lines:
			if s is Dictionary and s.get("type","") != "polygon":
				var id := int(s.get("id", 0))
				if id > 0:
					_upsert_from_data(id, true)

	if _strokes_dirty:
		_rebuild_stroke_batches()

	for S in _strokes:
		if S.color.a <= 0.0:
			continue
		if S.width <= 0.0:
			continue
		for chain in S.chains:
			match S.mode:
				TerrainBrush.DrawMode.SOLID:
					_draw_polyline_solid(chain, S.color, S.width)
				TerrainBrush.DrawMode.DASHED:
					_draw_polyline_dashed(chain, S.color, S.width, S.dash, S.gap)
				TerrainBrush.DrawMode.DOTTED:
					_draw_polyline_dotted(chain, S.color, S.width, max(2.0, S.gap))
				_:
					_draw_polyline_solid(chain, S.color, S.width)

## Insert/update a line by id from TerrainData and (optionally) rebuild recipe
func _upsert_from_data(id: int, rebuild_recipe: bool) -> void:
	var L: Variant = _find_line_by_id(id)
	if L == null:
		_items.erase(id)
		_strokes_dirty = true
		return
	var brush: TerrainBrush = L.get("brush", null)
	if brush == null or brush.feature_type != TerrainBrush.FeatureType.LINEAR:
		_items.erase(id)
		_strokes_dirty = true
		return
	var pts: PackedVector2Array = L.get("points", PackedVector2Array())
	if pts.size() < 2:
		_items.erase(id)
		_strokes_dirty = true
		return

	var safe_pts := renderer.clamp_shape_to_terrain(pts)

	var it: Dictionary = _items.get(id, {
		"pts": PackedVector2Array(),
		"safe_pts": PackedVector2Array(),
		"core_w": 0.0,
		"rec": {},
		"z": 0,
		"mode": TerrainBrush.DrawMode.SOLID,
		"stroke_col": Color(0,0,0,0),
		"fill_col": Color(0,0,0,0),
		"dash": 8.0,
		"gap": 6.0
	})

	it.pts = pts
	it.safe_pts = safe_pts

	if rebuild_recipe or it.rec == {}:
		var rec := brush.get_draw_recipe()
		var stroke_col: Color = (rec.stroke.color if rec.has("stroke") and "color" in rec.stroke else Color(0,0,0,0))
		var fill_col: Color   = (rec.fill.color   if rec.has("fill")   and "color" in rec.fill   else Color(0,0,0,0))
		var stroke_w: float   = (rec.stroke.width_px if rec.has("stroke") and "width_px" in rec.stroke else 1.0)
		var core_w: float = float(L.get("width_px", 0.0))
		if core_w <= 0.0:
			core_w = max(1.0, stroke_w)

		it.rec = rec
		it.z = int(brush.z_index)
		it.mode = int(rec.mode if rec.has("mode") else TerrainBrush.DrawMode.SOLID)
		it.stroke_col = stroke_col
		it.fill_col = fill_col
		it.core_w = core_w
		it.dash = float(rec.stroke.dash_px if rec.has("stroke") and "dash_px" in rec.stroke else 8.0)
		it.gap  = float(rec.stroke.gap_px  if rec.has("stroke") and "gap_px"  in rec.stroke else 6.0)

	_items[id] = it
	_strokes_dirty = true

func _refresh_geometry(id: int) -> void:
	if not _items.has(id):
		_upsert_from_data(id, false)
		return
	var L: Variant = _find_line_by_id(id)
	if L == null:
		_items.erase(id)
		_strokes_dirty = true
		return
	var pts: PackedVector2Array = L.get("points", PackedVector2Array())
	if pts.size() < 2:
		_items.erase(id)
		_strokes_dirty = true
		return
	var it = _items[id]
	it.pts = pts
	it.safe_pts = renderer.clamp_shape_to_terrain(pts)
	_items[id] = it
	_strokes_dirty = true

## Recompute recipe (colors/mode/widths) and geometry (since snapping may change)
func _refresh_recipe_and_geometry(id: int) -> void:
	_upsert_from_data(id, true)

## Build stroke groups (outline/core) per identical state and sort by z
func _rebuild_stroke_batches() -> void:
	_strokes_dirty = false
	_strokes.clear()
	if _items.is_empty():
		return

	var groups: Dictionary = {}
	for id in _items.keys():
		var it = _items[id]
		var core_w: float = it.core_w
		var stroke_w: float = float(it.rec.stroke.width_px if it.rec.has("stroke") and "width_px" in it.rec.stroke else 1.0)
		var outline_w := core_w + 2.0 * stroke_w

		var chain_outline: PackedVector2Array = it.safe_pts
		var chain_core: PackedVector2Array= it.safe_pts
		if snap_half_px_for_thin_strokes and (int(round(outline_w)) % 2 != 0):
			chain_outline = _offset_half_px(chain_outline)
		if snap_half_px_for_thin_strokes and (int(round(core_w)) % 2 != 0):
			chain_core = _offset_half_px(chain_core)

		var key_out := _stroke_key(it.mode, it.stroke_col, outline_w, it.z, it.dash, it.gap)
		if not groups.has(key_out):
			groups[key_out] = {
				"mode": it.mode, "color": it.stroke_col, "width": outline_w,
				"chains": [], "z": it.z, "dash": it.dash, "gap": it.gap
			}
		groups[key_out].chains.append(chain_outline)

		var key_core := _stroke_key(it.mode, it.fill_col, core_w, it.z, it.dash, it.gap)
		if not groups.has(key_core):
			groups[key_core] = {
				"mode": it.mode, "color": it.fill_col, "width": core_w,
				"chains": [], "z": it.z, "dash": it.dash, "gap": it.gap
			}
		groups[key_core].chains.append(chain_core)

	for k in groups.keys():
		_strokes.append(groups[k])
	_strokes.sort_custom(func(a, b): 
		return int(a.z) < int(b.z))

## Offset all points by half a pixel to align odd widths to pixel centers
func _offset_half_px(pts: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in pts: out.append(p + Vector2(0.5, 0.5))
	return out

## Draw a solid polyline
func _draw_polyline_solid(pts: PackedVector2Array, color: Color, width: float) -> void:
	if pts.size() < 2: 
		return
	draw_polyline(pts, color, width, antialias)

## Draw a dashed polyline with dash/gap in pixels
func _draw_polyline_dashed(pts: PackedVector2Array, color: Color, width: float, dash_px: float, gap_px: float) -> void:
	if pts.size() < 2: 
		return
	var dash: float = max(0.5, dash_px)
	var gap : float = max(0.5, gap_px)
	var period := dash + gap
	var phase := 0.0
	for i in range(pts.size() - 1):
		var a := pts[i]
		var b := pts[i + 1]
		var seg := b - a
		var length := seg.length()
		if length <= 1e-6: continue
		var dir := seg / length
		var t := 0.0
		if phase > 0.0: t = min(phase, length)
		while t < length:
			var t0 := t
			var t1: float = min(length, t + dash)
			if t1 > t0:
				draw_line(a + dir * t0, a + dir * t1, color, width, antialias)
			t += period
		var advanced := (phase if phase > 0.0 else 0.0)
		var remaining := length - advanced
		var cycles: float = floor(remaining / period)
		phase = length - (advanced + cycles * period)

## Draw a dotted polyline using circles spaced by step_px
func _draw_polyline_dotted(pts: PackedVector2Array, color: Color, width: float, step_px: float) -> void:
	if pts.size() < 2: 
		return
	var step: float = max(1.0, step_px)
	var r: float = max(0.5, width * 0.5)
	var phase := 0.0
	for i in range(pts.size() - 1):
		var a := pts[i]
		var b := pts[i + 1]
		var seg := b - a
		var length := seg.length()
		if length <= 1e-6: continue
		var dir := seg / length
		var t := 0.0
		if phase > 0.0: t = min(phase, length)
		while t <= length:
			draw_circle(a + dir * t, r, color)
			t += step
		var advanced := (phase if phase > 0.0 else 0.0)
		var remaining := length - advanced
		var cycles: float = floor(remaining / step)
		phase = length - (advanced + cycles * step)

## Stable key for batching strokes that share draw state
func _stroke_key(mode: int, color: Color, width: float, z: int, dash: float, gap: float) -> String:
	return "%d|%s|%.3f|%d|%.3f|%.3f" % [mode, color.to_html(), width, z, dash, gap]

## Find a line dictionary in TerrainData by id
func _find_line_by_id(id: int) -> Variant:
	if data == null: 
		return null
	for s in data.lines:
		if s is Dictionary and int(s.get("id", 0)) == id:
			return s
	return null
