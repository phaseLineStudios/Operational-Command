extends Control
class_name SurfaceLayer

## Antialiasing
@export var antialias: bool = true
## Enable for crisper 1px strokes
@export var snap_half_px_for_thin_strokes := true
## Max texture size for patterns
@export var max_pattern_size_px: int = 2048 

@onready var renderer: TerrainRender = get_owner()

var data: TerrainData
var _data_conn := false
var _dirty := true

## API to set Terrain Data
func set_data(d: TerrainData) -> void:
	if _data_conn and data and data.is_connected("changed", Callable(self, "_on_data_changed")):
		data.disconnect("changed", Callable(self, "_on_data_changed"))
		_data_conn = false

	data = d
	_dirty = true
	if data:
		data.changed.connect(_on_data_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED)
		_data_conn = true
	queue_redraw()

## Redraw if terrain data changes
func _on_data_changed() -> void:
	_dirty = true
	queue_redraw()

## Redraw if map is resized
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_redraw()

func _draw() -> void:
	if data == null or data.surfaces.is_empty():
		return

	var groups := {}
	for s in data.surfaces:
		if s == null or typeof(s) != TYPE_DICTIONARY: continue
		if s.get("type", "") != "polygon": continue
		if not s.has("points"): continue
		var brush: TerrainBrush = s.get("brush", null)
		if brush == null or brush.feature_type != TerrainBrush.FeatureType.AREA:
			continue
		var pts: PackedVector2Array = s.points
		if pts.size() < 3:
			continue

		var clamped := renderer.clamp_shape_to_terrain(pts)
		if clamped.size() < 3:
			continue

		var key := _brush_key(brush)
		if not groups.has(key):
			groups[key] = {
				"brush": brush,
				"z": int(brush.z_index),
				"polys": []
			}
		groups[key].polys.append(clamped)

	var merged_to_draw: Array = []
	for key in groups.keys():
		var g = groups[key]
		var polys: Array = g.polys
		var merged: Array = _union_polys(polys)
		if not merged.is_empty():
			merged_to_draw.append({
				"brush": g.brush,
				"z": g.z,
				"polys": merged
			})

	merged_to_draw.sort_custom(func(a, b):
		return int(a.z) < int(b.z)
	)

	for item in merged_to_draw:
		var brush: TerrainBrush = item.brush
		var rec := brush.get_draw_recipe()
		var fill_col: Color = rec.fill.color if rec.has("fill") and "color" in rec.fill else Color(0,0,0,0)
		var stroke_col: Color = rec.stroke.color if rec.has("stroke") and "color" in rec.stroke else Color(0,0,0,0)
		var stroke_w: float = rec.stroke.width_px if rec.has("stroke") and "width_px" in rec.stroke else 1.0
		var mode: int = int(rec.mode if rec.has("mode") else TerrainBrush.DrawMode.SOLID)

		for poly: PackedVector2Array in item.polys:
			match mode:
				TerrainBrush.DrawMode.SOLID:
					if fill_col.a > 0.0:
						draw_colored_polygon(poly, fill_col, PackedVector2Array(), null)
				TerrainBrush.DrawMode.HATCHED:
					if fill_col.a > 0.0:
						var spacing := float(rec.fill.hatch_spacing_px if "hatch_spacing_px" in rec.fill else 8.0)
						var angle   := float(rec.fill.hatch_angle_deg   if "hatch_angle_deg"   in rec.fill else 45.0)
						_fill_hatched(poly, fill_col, spacing, angle)
				TerrainBrush.DrawMode.SYMBOL_TILED:
					var tex: Texture2D = rec.symbol.tex if rec.has("symbol") and "tex" in rec.symbol else null
					if tex != null and tex.get_width() > 0 and tex.get_height() > 0:
						var spacing_px := float(rec.symbol.spacing_px if "spacing_px" in rec.symbol else 24.0)
						var sym_scale := float(rec.symbol.scale if "scale" in rec.symbol else 1.0)
						_fill_symbol_tiled(poly, tex, spacing_px, sym_scale)
					elif fill_col.a > 0.0:
						draw_colored_polygon(poly, fill_col, PackedVector2Array(), null)
				_:
					if fill_col.a > 0.0:
						draw_colored_polygon(poly, fill_col, PackedVector2Array(), null)

			if stroke_col.a > 0.0 and stroke_w > 0.0:
				var outline := poly
				if snap_half_px_for_thin_strokes and int(round(stroke_w)) % 2 != 0:
					outline = _offset_half_px(outline)

				match mode:
					TerrainBrush.DrawMode.DASHED:
						var dash: float = rec.stroke.dash_px if "dash_px" in rec.stroke else 8.0
						var gap: float  = rec.stroke.gap_px  if "gap_px"  in rec.stroke else 6.0
						_draw_polyline_dashed(_closed_copy(outline, true), stroke_col, stroke_w, dash, gap)
					_:
						_draw_polyline_closed(_closed_copy(outline, true), stroke_col, stroke_w)

func _closed_copy(pts: PackedVector2Array, closed: bool) -> PackedVector2Array:
	if closed:
		if pts[0].distance_to(pts[pts.size()-1]) > 1e-5:
			var c := pts.duplicate(); c.append(pts[0]); return c
	return pts.duplicate()

func _offset_half_px(pts: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in pts:
		out.append(p + Vector2(0.5, 0.5))
	return out

## Draw hatched fill by rasterizing a hatch pattern into a temporary image
func _fill_hatched(pts: PackedVector2Array, color: Color, spacing_px: float, angle_deg: float) -> void:
	var bbox := _poly_bbox(pts)
	if bbox.size.x <= 1.0 or bbox.size.y <= 1.0: return

	var iw := int(clamp(ceil(bbox.size.x), 1.0, float(max_pattern_size_px)))
	var ih := int(clamp(ceil(bbox.size.y), 1.0, float(max_pattern_size_px)))

	var img := Image.create(iw, ih, false, Image.FORMAT_RGBA8)

	var rad := deg_to_rad(angle_deg)
	var c := cos(rad)
	var s := sin(rad)
	var inv_spacing: float = 1.0 / max(1.0, spacing_px)
	var line_alpha := color.a

	for y in ih:
		for x in iw:
			var xf := float(x)
			var yf := float(y)
			var u := xf * c + yf * s
			var f: float = abs(fmod(u * inv_spacing, 1.0))
			if f < 0.05 or f > 0.95:
				img.set_pixel(x, y, Color(color.r, color.g, color.b, line_alpha))
			else:
				img.set_pixel(x, y, Color(0,0,0,0))

	var _tex := ImageTexture.create_from_image(img)
	var uvs := PackedVector2Array()
	for p in pts:
		uvs.append(p - bbox.position)

	# TODO Create this helper
	# draw_textured_polygon(pts, tex, uvs, Color.WHITE, null, antialias)

## Draw symbol-tiled fill by blitting the symbol into a temporary image
func _fill_symbol_tiled(pts: PackedVector2Array, symbol: Texture2D, spacing_px: float, sym_scale: float) -> void:
	var bbox := _poly_bbox(pts)
	if bbox.size.x <= 1.0 or bbox.size.y <= 1.0: return

	var iw := int(clamp(ceil(bbox.size.x), 1.0, float(max_pattern_size_px)))
	var ih := int(clamp(ceil(bbox.size.y), 1.0, float(max_pattern_size_px)))

	var img := Image.create(iw, ih, false, Image.FORMAT_RGBA8)
	img.fill(Color(0,0,0,0))

	var sym_img := symbol.get_image()
	if sym_img == null or sym_img.is_empty():
		return
	var sw: int = max(1, int(round(sym_img.get_width()  * max(0.01, sym_scale))))
	var sh: int = max(1, int(round(sym_img.get_height() * max(0.01, sym_scale))))
	var sym_scaled := sym_img.duplicate()
	sym_scaled.resize(sw, sh, Image.INTERPOLATE_BILINEAR)

	var step: float = max(1.0, spacing_px)
	for y in range(0, ih, step):
		for x in range(0, iw, step):
			var dst := Rect2i(Vector2i(x, y), Vector2i(sw, sh))
			var clipped := dst.intersection(Rect2i(Vector2i(0,0), Vector2i(iw, ih)))
			if clipped.size.x <= 0 or clipped.size.y <= 0:
				continue
				
			var src := Rect2i(
				Vector2i(max(0, -dst.position.x), max(0, -dst.position.y)),
				clipped.size
			)
			img.blit_rect(sym_scaled, src, clipped.position)

	var _tex := ImageTexture.create_from_image(img)
	var uvs := PackedVector2Array()
	for p in pts:
		uvs.append(p - bbox.position)
	
	# TODO Create this helper
	# draw_textured_polygon(pts, tex, uvs, Color.WHITE, null, antialias)

## Get boundary box for polygon
func _poly_bbox(pts: PackedVector2Array) -> Rect2:
	var minp := pts[0]
	var maxp := pts[0]
	for i in range(1, pts.size()):
		var p := pts[i]
		minp.x = min(minp.x, p.x); minp.y = min(minp.y, p.y)
		maxp.x = max(maxp.x, p.x); maxp.y = max(maxp.y, p.y)
	return Rect2(minp, maxp - minp)

## Draw a closed polyline
func _draw_polyline_closed(pts: PackedVector2Array, color: Color, width: float) -> void:
	if pts.size() < 2: return
	# draw_polyline doesn't “close”, so draw the chain and close manually if needed
	draw_polyline(pts, color, width, antialias)
	if pts[0].distance_to(pts[pts.size()-1]) > 1e-5:
		draw_line(pts[pts.size()-1], pts[0], color, width, antialias)

## Draw a dashed polyline
func _draw_polyline_dashed(pts: PackedVector2Array, color: Color, width: float, dash_px: float, gap_px: float) -> void:
	if pts.size() < 2: return
	var closed := pts[0].distance_to(pts[pts.size()-1]) <= 1e-5
	var total := pts.size() - 1
	for i in total:
		_dash_segment(pts[i], pts[i+1], color, width, dash_px, gap_px)
	if closed == false and false:
		pass

## Draw dash segment
func _dash_segment(a: Vector2, b: Vector2, color: Color, width: float, dash_px: float, gap_px: float) -> void:
	var seg_len := a.distance_to(b)
	if seg_len <= 1e-6:
		return
	var dir := (b - a) / seg_len
	var step: float = max(0.5, dash_px + gap_px)
	var t := 0.0
	while t < seg_len:
		var t0 := t
		var t1: float = min(seg_len, t + dash_px)
		if t1 > t0:
			var p0 := a + dir * t0
			var p1 := a + dir * t1
			draw_line(p0, p1, color, width, antialias)
		t += step

## Key to group polygons that share style
func _brush_key(brush: TerrainBrush) -> String:
	if brush == null: return ""
	return (brush.resource_path if brush.resource_path != "" else "id:%s" % brush.get_instance_id())

## Boolean union for an array of polygons.
func _union_polys(polys: Array) -> Array:
	if polys.is_empty():
		return []

	var clean: Array = []
	for p in polys:
		var s := _sanitize_polygon(p)
		if s.size() >= 3 and abs(_polygon_area(s)) > 1e-6:
			clean.append(s)
	if clean.is_empty():
		return []

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
				for r in res:
					new_acc.append(r)
				merged_any = true
		if not merged_any:
			new_acc.append(b)

		acc = new_acc
	return acc

## Remove duplicate closing vertex, collapse near-duplicates, ensure >= 3 verts.
func _sanitize_polygon(pts_in: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	if pts_in.size() < 3:
		return out

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

	if out.size() < 3:
		return PackedVector2Array()
	return out

## Compute signed polygon area (shoelace formula).
static func _polygon_area(pts: PackedVector2Array) -> float:
	var n := pts.size()
	if n < 3:
		return 0.0
	var area := 0.0
	for i in range(n):
		var j := (i + 1) % n
		area += pts[i].x * pts[j].y - pts[j].x * pts[i].y
	return area * 0.5
