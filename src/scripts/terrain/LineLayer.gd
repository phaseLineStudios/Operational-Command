extends Control
class_name LineLayer

## Antialiasing
@export var antialias: bool = true
## Enable for crisper 1px strokes (snap 0.5 px)
@export var snap_half_px_for_thin_strokes := true

var data: TerrainData
var _data_conn := false

# ---------- API ----------

func set_data(d: TerrainData) -> void:
	if _data_conn and data and data.is_connected("changed", Callable(self, "_on_data_changed")):
		data.disconnect("changed", Callable(self, "_on_data_changed"))
		_data_conn = false

	data = d
	if data:
		data.changed.connect(_on_data_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED)
		_data_conn = true
	queue_redraw()

# ---------- Signals / Notifications ----------

func _on_data_changed() -> void:
	queue_redraw()

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_redraw()

# ---------- Draw ----------

func _draw() -> void:
	if data == null or data.lines == null or data.lines.is_empty():
		return

	# Collect linear features
	var lines: Array = []
	for s in data.lines:
		if s == null or not (s is Dictionary):
			continue
		if s.get("type", "") != "polyline":
			continue
		var brush: TerrainBrush = s.get("brush", null)
		if brush == null or brush.feature_type != TerrainBrush.FeatureType.LINEAR:
			continue

		var pts: PackedVector2Array = s.get("points", PackedVector2Array())
		if pts.size() < 2:
			continue

		var closed: bool = bool(s.get("closed", false))
		var width_px: float = float(s.get("width_px", 0.0))
		if width_px <= 0.0:
			# Fallback to brush stroke width if tool width missing
			var rec := brush.get_draw_recipe()
			width_px = float(rec.stroke.width_px if rec.has("stroke") and "width_px" in rec.stroke else 2.0)

		lines.append({
			"points": pts,
			"closed": closed,
			"width_px": width_px,
			"brush": brush
		})

	# Sort by brush z-index (lower first, higher drawn later = on top)
	lines.sort_custom(func(a, b):
		var za: int = a.brush.z_index
		var zb: int = b.brush.z_index
		return za < zb
	)

	# Draw all lines
	for item in lines:
		var pts: PackedVector2Array = item.points
		var closed: bool = item.closed
		var width_px: float = item.width_px
		var brush: TerrainBrush = item.brush
		var rec := brush.get_draw_recipe()

		# Optional "fill" underlay for linear features: draw a solid under-stroke
		# at (width_px - 1) so the final visible stroke width remains width_px.
		if rec.has("fill") and "color" in rec.fill:
			var fill_col: Color = rec.fill.color
			if fill_col.a > 0.0:
				var under_w: float = max(0.5, width_px - 1.0)
				var chain := _polyline_chain(pts, closed)
				if snap_half_px_for_thin_strokes and int(round(under_w)) % 2 != 0:
					chain = _offset_half_px(chain)
				_draw_polyline_solid(chain, fill_col, under_w)

		# Outline using brush mode/color; width is from the tool (width_px)
		var stroke_col: Color = rec.stroke.color if rec.has("stroke") and "color" in rec.stroke else Color(0,0,0,0)
		if stroke_col.a <= 0.0:
			continue

		var chain2 := _polyline_chain(pts, closed)
		if snap_half_px_for_thin_strokes and int(round(width_px)) % 2 != 0:
			chain2 = _offset_half_px(chain2)

		var mode: int = int(rec.mode if rec.has("mode") else TerrainBrush.DrawMode.SOLID)
		match mode:
			TerrainBrush.DrawMode.SOLID:
				_draw_polyline_solid(chain2, stroke_col, width_px)
			TerrainBrush.DrawMode.DASHED:
				var dash_px: float = float(rec.stroke.dash_px if rec.has("stroke") and "dash_px" in rec.stroke else 8.0)
				var gap_px: float  = float(rec.stroke.gap_px  if rec.has("stroke") and "gap_px"  in rec.stroke else 6.0)
				_draw_polyline_dashed(chain2, stroke_col, width_px, dash_px, gap_px)
			TerrainBrush.DrawMode.DOTTED:
				_draw_polyline_dotted(chain2, stroke_col, width_px, max(2.0, width_px * 2.0))
			_:
				_draw_polyline_solid(chain2, stroke_col, width_px)

# ---------- Helpers (geometry / styling) ----------

func _polyline_chain(pts: PackedVector2Array, closed: bool) -> PackedVector2Array:
	if not closed:
		return pts.duplicate()
	# Ensure last equals first for closed rendering helper(s)
	if pts.size() >= 2 and pts[0].distance_to(pts[pts.size()-1]) > 1e-5:
		var c := pts.duplicate()
		c.append(pts[0])
		return c
	return pts.duplicate()

func _offset_half_px(pts: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in pts:
		out.append(p + Vector2(0.5, 0.5))
	return out

# ---------- Stroke implementations ----------

func _draw_polyline_solid(pts: PackedVector2Array, color: Color, width: float) -> void:
	if pts.size() < 2:
		return
	draw_polyline(pts, color, width, antialias)

func _draw_polyline_dashed(pts: PackedVector2Array, color: Color, width: float, dash_px: float, gap_px: float) -> void:
	if pts.size() < 2:
		return
	var period: float = max(0.5, dash_px + gap_px)
	for i in range(pts.size() - 1):
		_dash_segment(pts[i], pts[i + 1], color, width, dash_px, period)

func _dash_segment(a: Vector2, b: Vector2, color: Color, width: float, dash_px: float, period: float) -> void:
	var seg := b - a
	var length := seg.length()
	if length <= 1e-6:
		return
	var dir := seg / length
	var pos := 0.0
	while pos < length:
		var t0 := pos
		var t1: float = min(length, pos + dash_px)
		if t1 > t0:
			draw_line(a + dir * t0, a + dir * t1, color, width, antialias)
		pos += period

func _draw_polyline_dotted(pts: PackedVector2Array, color: Color, width: float, step_px: float) -> void:
	if pts.size() < 2:
		return
	var step: float = max(1.0, step_px)
	var r: float = max(0.5, width * 0.5)
	for i in range(pts.size() - 1):
		var a := pts[i]
		var b := pts[i + 1]
		var seg := b - a
		var length := seg.length()
		if length <= 1e-6:
			continue
		var dir := seg / length
		var t := 0.0
		while t <= length:
			draw_circle(a + dir * t, r, color)
			t += step
