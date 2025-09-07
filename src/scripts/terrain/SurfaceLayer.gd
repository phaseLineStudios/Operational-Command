extends Control
class_name SurfaceLayer

## Renders area surfaces (polygons) with per-id caching and minimal rebuilds.
## Only recalculates groups affected by TerrainData.surfaces_changed.

@export var antialias: bool = true
@export var snap_half_px_for_thin_strokes := true
@export var max_pattern_size_px: int = 2048

@onready var renderer: TerrainRender = get_owner()

## Emitted when any group was rebuilt (dirty groups only)
signal batches_rebuilt()

var data: TerrainData
var _data_conn := false

var _groups: Dictionary = {}
var _id_to_key: Dictionary = {}
var _dirty_all := true

func set_data(d: TerrainData) -> void:
	if _data_conn and data and data.is_connected("surfaces_changed", Callable(self, "_on_surfaces_changed")):
		data.disconnect("surfaces_changed", Callable(self, "_on_surfaces_changed"))
		_data_conn = false

	data = d
	_dirty_all = true
	_groups.clear()
	_id_to_key.clear()

	if data:
		data.surfaces_changed.connect(_on_surfaces_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED)
		_data_conn = true

	queue_redraw()

## Force a full rebuild (rare)
func mark_dirty() -> void:
	_dirty_all = true
	queue_redraw()

func _on_surfaces_changed(kind: String, ids: PackedInt32Array) -> void:
	match kind:
		"reset":
			_dirty_all = true
		"added":
			for id in ids: _upsert_from_data(id, false)
		"removed":
			for id in ids: _remove_id(id)
		"points":
			for id in ids: _refresh_geometry_same_group(id)
		"brush", "meta":
			for id in ids: _move_if_key_changed(id)
		_:
			_dirty_all = true

	queue_redraw()

func _draw() -> void:
	if data == null:
		return

	if _dirty_all:
		_rebuild_all_from_data()
	else:
		_rebuild_dirty_groups()

	var glist := _sorted_groups()
	for g in glist:
		var rec: Dictionary = g.rec
		var fill_col: Color = (rec.fill.color if rec.has("fill") and "color" in rec.fill else Color(0,0,0,0))
		var stroke_col: Color = (rec.stroke.color if rec.has("stroke") and "color" in rec.stroke else Color(0,0,0,0))
		var stroke_w: float = (rec.stroke.width_px if rec.has("stroke") and "width_px" in rec.stroke else 1.0)
		var mode: int = int(rec.mode if rec.has("mode") else TerrainBrush.DrawMode.SOLID)

		for poly: PackedVector2Array in g.merged:
			match mode:
				TerrainBrush.DrawMode.SOLID:
					if fill_col.a > 0.0 and poly.size() >= 3:
						draw_colored_polygon(poly, fill_col, PackedVector2Array(), null)
				TerrainBrush.DrawMode.HATCHED:
					if fill_col.a > 0.0 and poly.size() >= 3:
						# Optional: bake hatch to temp image; fallback to solid if you prefer
						draw_colored_polygon(poly, fill_col, PackedVector2Array(), null)
				TerrainBrush.DrawMode.SYMBOL_TILED:
					var tex: Texture2D = (rec.symbol.tex if rec.has("symbol") and "tex" in rec.symbol else null)
					if tex and poly.size() >= 3:
						draw_colored_polygon(poly, Color.WHITE, PackedVector2Array(), tex)
					elif fill_col.a > 0.0 and poly.size() >= 3:
						draw_colored_polygon(poly, fill_col, PackedVector2Array(), null)
				_:
					if fill_col.a > 0.0 and poly.size() >= 3:
						draw_colored_polygon(poly, fill_col, PackedVector2Array(), null)

			if stroke_col.a > 0.0 and stroke_w > 0.0 and poly.size() >= 2:
				var outline := poly
				if snap_half_px_for_thin_strokes and int(round(stroke_w)) % 2 != 0:
					outline = _offset_half_px(outline)
				_draw_polyline_closed(_closed_copy(outline, true), stroke_col, stroke_w)

func _rebuild_all_from_data() -> void:
	_groups.clear()
	_id_to_key.clear()
	_dirty_all = false

	if data == null or data.surfaces.is_empty():
		emit_signal("batches_rebuilt")
		return

	for s in data.surfaces:
		if s == null or typeof(s) != TYPE_DICTIONARY: continue
		if s.get("type","") != "polygon": continue
		var brush: TerrainBrush = s.get("brush", null)
		if brush == null or brush.feature_type != TerrainBrush.FeatureType.AREA: continue
		var id := int(s.get("id", 0)); if id <= 0: continue

		var pts: PackedVector2Array = s.get("points", PackedVector2Array())
		if pts.size() < 3: continue

		var clamped := renderer.clamp_shape_to_terrain(pts)
		if clamped.size() < 3: continue

		var key := _brush_key(brush)
		_ensure_group(key, brush)

		_groups[key].polys[id] = clamped
		_groups[key].bboxes[id] = _poly_bbox(clamped)
		_id_to_key[id] = key

	for key in _groups.keys():
		_groups[key].merged = _union_group(_groups[key].polys.values())
		_groups[key].dirty = false

	emit_signal("batches_rebuilt")

func _rebuild_dirty_groups() -> void:
	var rebuilt_any := false
	for key in _groups.keys():
		var G = _groups[key]
		if not G.dirty: continue
		G.merged = _union_group(G.polys.values())
		G.dirty = false
		rebuilt_any = true
	if rebuilt_any:
		emit_signal("batches_rebuilt")

func _upsert_from_data(id: int, rebuild_old_key: bool) -> void:
	var item: Variant = _find_surface_by_id(id)
	if item == null: return
	if item.get("type","") != "polygon": return
	var brush: TerrainBrush = item.get("brush", null)
	if brush == null or brush.feature_type != TerrainBrush.FeatureType.AREA: return
	var pts: PackedVector2Array = item.get("points", PackedVector2Array())
	if pts.size() < 3: return

	var clamped := renderer.clamp_shape_to_terrain(pts)
	if clamped.size() < 3: return

	var new_key := _brush_key(brush)
	_ensure_group(new_key, brush)

	var old_key: Variant = _id_to_key.get(id, null)
	if rebuild_old_key and old_key != null and old_key != new_key and _groups.has(old_key):
		_groups[old_key].polys.erase(id)
		_groups[old_key].bboxes.erase(id)
		_groups[old_key].dirty = true

	_groups[new_key].polys[id] = clamped
	_groups[new_key].bboxes[id] = _poly_bbox(clamped)
	_groups[new_key].dirty = true
	_id_to_key[id] = new_key

func _remove_id(id: int) -> void:
	var key: Variant = _id_to_key.get(id, null)
	if key == null: return
	_id_to_key.erase(id)
	if not _groups.has(key): return
	_groups[key].polys.erase(id)
	_groups[key].bboxes.erase(id)
	_groups[key].dirty = true

func _refresh_geometry_same_group(id: int) -> void:
	var key: Variant = _id_to_key.get(id, null)
	var item: Variant = _find_surface_by_id(id)
	if item == null:
		_remove_id(id)
		return
	var brush: TerrainBrush = item.get("brush", null)
	var pts: PackedVector2Array = item.get("points", PackedVector2Array())
	if brush == null or pts.size() < 3:
		_remove_id(id)
		return

	var clamped := renderer.clamp_shape_to_terrain(pts)
	if clamped.size() < 3:
		_remove_id(id)
		return

	var new_key := _brush_key(brush)
	if key == null or key != new_key:
		_upsert_from_data(id, true)
		return

	if _groups.has(key):
		_groups[key].polys[id] = clamped
		_groups[key].bboxes[id] = _poly_bbox(clamped)
		_groups[key].dirty = true

func _move_if_key_changed(id: int) -> void:
	var item: Variant = _find_surface_by_id(id)
	if item == null:
		_remove_id(id)
		return
	var brush: TerrainBrush = item.get("brush", null)
	var new_key: Variant = _brush_key(brush) if brush else null
	var old_key: Variant = _id_to_key.get(id, null)
	if new_key == null:
		_remove_id(id)
		return
	if old_key == new_key:
		_refresh_geometry_same_group(id)
	else:
		_upsert_from_data(id, true)

func _ensure_group(key: String, brush: TerrainBrush) -> void:
	if _groups.has(key): return
	var rec := brush.get_draw_recipe()
	_groups[key] = {
		"brush": brush,
		"z": int(brush.z_index),
		"rec": rec,
		"polys": {},
		"bboxes": {},
		"merged": [],
		"dirty": true
	}

func _sorted_groups() -> Array:
	var arr: Array = []
	for key in _groups.keys(): arr.append(_groups[key])
	arr.sort_custom(func(a, b): return int(a.z) < int(b.z))
	return arr

func _union_group(polys: Array) -> Array:
	return _union_polys(polys)

func _closed_copy(pts: PackedVector2Array, closed: bool) -> PackedVector2Array:
	if closed:
		if pts[0].distance_to(pts[pts.size()-1]) > 1e-5:
			var c := pts.duplicate(); c.append(pts[0]); return c
	return pts.duplicate()

func _offset_half_px(pts: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in pts: out.append(p + Vector2(0.5, 0.5))
	return out

func _poly_bbox(pts: PackedVector2Array) -> Rect2:
	var minp := pts[0]
	var maxp := pts[0]
	for i in range(1, pts.size()):
		var p := pts[i]
		minp.x = min(minp.x, p.x); minp.y = min(minp.y, p.y)
		maxp.x = max(maxp.x, p.x); maxp.y = max(maxp.y, p.y)
	return Rect2(minp, maxp - minp)

func _draw_polyline_closed(pts: PackedVector2Array, color: Color, width: float) -> void:
	if pts.size() < 2: return
	draw_polyline(pts, color, width, antialias)
	if pts[0].distance_to(pts[pts.size()-1]) > 1e-5:
		draw_line(pts[pts.size()-1], pts[0], color, width, antialias)

func _brush_key(brush: TerrainBrush) -> String:
	if brush == null: return ""
	return (brush.resource_path if brush.resource_path != "" else "id:%s" % brush.get_instance_id())

func _union_polys(polys: Array) -> Array:
	if polys.is_empty(): return []
	var clean: Array = []
	for p in polys:
		var s := _sanitize_polygon(p)
		if s.size() >= 3 and abs(_polygon_area(s)) > 1e-6:
			clean.append(s)
	if clean.is_empty(): return []
	var acc: Array = [clean[0]]
	for i in range(1, clean.size()):
		var b: PackedVector2Array = clean[i]
		var new_acc: Array = []
		var merged_any := false
		for a in acc:
			var res: Array = Geometry2D.merge_polygons(a, b)
			if res.is_empty():
				new_acc.append(a)
			else:
				for r in res: new_acc.append(r)
				merged_any = true
		if not merged_any:
			new_acc.append(b)
		acc = new_acc
	return acc

func _sanitize_polygon(pts_in: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	if pts_in.size() < 3: return out
	var n := pts_in.size()
	var first := pts_in[0]
	var last  := pts_in[n - 1]
	var end_n := n - 1 if first.distance_squared_to(last) < 1e-12 else n
	var eps2 := 1e-10
	var prev := Vector2.INF
	for i in range(end_n):
		var p := pts_in[i]
		if not prev.is_finite() or prev.distance_squared_to(p) > eps2:
			out.append(p)
		prev = p
	if out.size() < 3: return PackedVector2Array()
	return out

static func _polygon_area(pts: PackedVector2Array) -> float:
	var n := pts.size()
	if n < 3: return 0.0
	var area := 0.0
	for i in n:
		var j := (i + 1) % n
		area += pts[i].x * pts[j].y - pts[j].x * pts[i].y
	return area * 0.5

func _find_surface_by_id(id: int) -> Variant:
	if data == null: return null
	for s in data.surfaces:
		if s is Dictionary and int(s.get("id", 0)) == id:
			return s
	return null
