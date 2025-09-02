extends Control
class_name SurfaceLayer

## Antialiasing
@export var antialias: bool = true
## Enable for crisper 1px strokes
@export var snap_half_px_for_thin_strokes := true
## Max texture size for patterns
@export var max_pattern_size_px: int = 2048 

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

	# Filter AREA only and sort by z_index
	var polys: Array = []
	for s in data.surfaces:
		if s == null or not (s is Dictionary): continue
		if not s.has("points"): continue
		var brush: TerrainBrush = s.get("brush", null)
		if brush == null: continue
		if brush.feature_type != TerrainBrush.FeatureType.AREA: continue
		var pts: PackedVector2Array = s.points
		if pts.size() < 3: continue
		var closed := bool(s.get("closed", true))
		polys.append({
			"points": pts,
			"closed": closed,
			"brush": brush
		})

	polys.sort_custom(func(a, b):
		var za: int = a.brush.z_index
		var zb: int = b.brush.z_index
		return za < zb
	)

	for item in polys:
		var pts: PackedVector2Array = item.points
		var closed: bool = item.closed
		var brush: TerrainBrush = item.brush
		var rec := brush.get_draw_recipe()

		var fill_col: Color = rec.fill.color if rec.has("fill") and "color" in rec.fill else Color(0,0,0,0)
		match int(rec.mode if rec.has("mode") else TerrainBrush.DrawMode.SOLID):
			TerrainBrush.DrawMode.SOLID:
				if fill_col.a > 0.0:
					draw_colored_polygon(pts, fill_col, PackedVector2Array(), null)
			TerrainBrush.DrawMode.HATCHED:
				if fill_col.a > 0.0:
					var spacing := float(rec.fill.hatch_spacing_px if "hatch_spacing_px" in rec.fill else 8.0)
					var angle   := float(rec.fill.hatch_angle_deg   if "hatch_angle_deg"   in rec.fill else 45.0)
					_fill_hatched(pts, fill_col, spacing, angle)
			TerrainBrush.DrawMode.SYMBOL_TILED:
				var tex: Texture2D = rec.symbol.tex if rec.has("symbol") and "tex" in rec.symbol else null
				if tex != null and tex.get_width() > 0 and tex.get_height() > 0:
					var spacing_px := float(rec.symbol.spacing_px if "spacing_px" in rec.symbol else 24.0)
					var sym_scale := float(rec.symbol.scale if "scale" in rec.symbol else 1.0)
					_fill_symbol_tiled(pts, tex, spacing_px, sym_scale)
				elif fill_col.a > 0.0:
					# Fallback: solid if no symbol
					draw_colored_polygon(pts, fill_col, PackedVector2Array(), null)
			_:
				# Fallback: solid
				if fill_col.a > 0.0:
					draw_colored_polygon(pts, fill_col, PackedVector2Array(), null)

		# Outline
		var stroke_col: Color = rec.stroke.color if rec.has("stroke") and "color" in rec.stroke else Color(0,0,0,0)
		var stroke_w: float = rec.stroke.width_px if rec.has("stroke") and "width_px" in rec.stroke else 1.0
		if stroke_col.a > 0.0 and stroke_w > 0.0:
			var mode: TerrainBrush.DrawMode = rec.mode if rec.has("mode") else TerrainBrush.DrawMode.SOLID
			var outline: PackedVector2Array = _closed_copy(pts, closed)

			if snap_half_px_for_thin_strokes and int(round(stroke_w)) % 2 != 0:
				# center odd-width strokes on pixel centers for crispness
				outline = _offset_half_px(outline)

			match mode:
				TerrainBrush.DrawMode.SOLID:
					_draw_polyline_closed(outline, stroke_col, stroke_w)
				TerrainBrush.DrawMode.DASHED:
					var dash: float = rec.stroke.dash_px if "dash_px" in rec.stroke else 8.0
					var gap: float = rec.stroke.gap_px  if "gap_px"  in rec.stroke else 6.0
					_draw_polyline_dashed(outline, stroke_col, stroke_w, dash, gap)
				_:
					# DOTTED/HATCHED/SYMBOL_TILED for outlines not implemented here
					_draw_polyline_closed(outline, stroke_col, stroke_w)

func _closed_copy(pts: PackedVector2Array, closed: bool) -> PackedVector2Array:
	if closed:
		# ensure last==first for easy “closed” drawing
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
	# draw_polyline doesn't “close”, so draw the chain and close manually if needed
	draw_polyline(pts, color, width, antialias)
	if pts[0].distance_to(pts[pts.size()-1]) > 1e-5:
		draw_line(pts[pts.size()-1], pts[0], color, width, antialias)

func _draw_polyline_dashed(pts: PackedVector2Array, color: Color, width: float, dash_px: float, gap_px: float) -> void:
	if pts.size() < 2: return
	var closed := pts[0].distance_to(pts[pts.size()-1]) <= 1e-5
	var total := pts.size() - 1
	for i in total:
		_dash_segment(pts[i], pts[i+1], color, width, dash_px, gap_px)
	# close if needed
	if closed == false and false:
		# (no-op; we already have explicit last==first when closed)
		pass

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
