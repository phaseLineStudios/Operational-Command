extends Control
class_name LineLayer

@export var antialias: bool = true
@export var snap_half_px_for_thin_strokes := true

@onready var renderer: TerrainRender = get_owner()

var data: TerrainData
var _data_conn := false

func set_data(d: TerrainData) -> void:
	if _data_conn and data and data.is_connected("changed", Callable(self, "_on_data_changed")):
		data.disconnect("changed", Callable(self, "_on_data_changed"))
		_data_conn = false
	data = d
	if data:
		data.changed.connect(_on_data_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED)
		_data_conn = true
	queue_redraw()

func _on_data_changed() -> void:
	queue_redraw()

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_redraw()

func _draw() -> void:
	if data == null or data.lines == null or data.lines.is_empty():
		return

	var lines: Array = []
	for s in data.lines:
		if s == null or not (s is Dictionary): continue
		var brush: TerrainBrush = s.get("brush", null)
		if brush == null or brush.feature_type != TerrainBrush.FeatureType.LINEAR: continue

		var pts: PackedVector2Array = s.get("points", PackedVector2Array())
		if pts.size() < 2: continue
		var safe_pts := renderer.clamp_shape_to_terrain(pts)

		var rec := brush.get_draw_recipe()
		var fill_col: Color   = rec.fill.color   if rec.has("fill")   and "color" in rec.fill   else Color(0,0,0,0)
		var stroke_col: Color = rec.stroke.color if rec.has("stroke") and "color" in rec.stroke else Color(0,0,0,0)
		var stroke_w: float   = rec.stroke.width_px if rec.has("stroke") and "width_px" in rec.stroke else 1.0
		var mode: int         = int(rec.mode if rec.has("mode") else TerrainBrush.DrawMode.SOLID)

		var core_w: float = float(s.get("width_px", 0.0))
		if core_w <= 0.0:
			core_w = max(1.0, stroke_w)
	
		lines.append({
			"pts": safe_pts,
			"fill": fill_col,
			"stroke": stroke_col,
			"core_w": core_w,
			"outline_w": stroke_w,
			"mode": mode,
			"z": brush.z_index,
			"dash": float(rec.stroke.dash_px if rec.has("stroke") and "dash_px" in rec.stroke else 8.0),
			"gap":  float(rec.stroke.gap_px  if rec.has("stroke") and "gap_px"  in rec.stroke else 6.0)
		})

	lines.sort_custom(func(a, b): return int(a.z) < int(b.z))

	for L in lines:
		var chain: PackedVector2Array = L.pts.duplicate()
		var outer_w: float = L.core_w + 2.0 * L.outline_w
		if snap_half_px_for_thin_strokes:
			if int(round(outer_w)) % 2 != 0:
				chain = _offset_half_px(chain)

		if L.stroke.a > 0.0 and outer_w > 0.0:
			match L.mode:
				TerrainBrush.DrawMode.SOLID:
					_draw_polyline_solid(chain, L.stroke, outer_w)
				TerrainBrush.DrawMode.DASHED:
					_draw_polyline_dashed_continuous(chain, L.stroke, outer_w, L.dash, L.gap)
				TerrainBrush.DrawMode.DOTTED:
					_draw_polyline_dotted_continuous(chain, L.stroke, outer_w, max(2.0, L.gap))

		if L.fill.a > 0.0 and L.core_w > 0.0:
			match L.mode:
				TerrainBrush.DrawMode.SOLID:
					_draw_polyline_solid(chain, L.fill, L.core_w)
				TerrainBrush.DrawMode.DASHED:
					_draw_polyline_dashed_continuous(chain, L.fill, L.core_w, L.dash, L.gap)
				TerrainBrush.DrawMode.DOTTED:
					_draw_polyline_dotted_continuous(chain, L.fill, L.core_w, max(2.0, L.gap))

func _offset_half_px(pts: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in pts: out.append(p + Vector2(0.5, 0.5))
	return out

func _draw_polyline_solid(pts: PackedVector2Array, color: Color, width: float) -> void:
	if pts.size() < 2: return
	draw_polyline(pts, color, width, antialias)

## Draw dashed line
func _draw_polyline_dashed_continuous(pts: PackedVector2Array, color: Color, width: float, dash_px: float, gap_px: float) -> void:
	if pts.size() < 2: return
	var dash: float = max(0.5, dash_px)
	var gap : float = max(0.5, gap_px)
	var period := dash + gap
	var phase := 0.0
	for i in range(pts.size() - 1):
		var a := pts[i]
		var b := pts[i + 1]
		var seg := b - a; 
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

## Draw dotted line
func _draw_polyline_dotted_continuous(pts: PackedVector2Array, color: Color, width: float, step_px: float) -> void:
	if pts.size() < 2: return
	var step: float = max(1.0, step_px)
	var r: float = max(0.5, width * 0.5)
	var phase := 0.0
	for i in range(pts.size() - 1):
		var a := pts[i]
		var b := pts[i + 1]
		var seg := b - a; 
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
