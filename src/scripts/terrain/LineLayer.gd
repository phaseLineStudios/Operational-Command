extends Control
class_name LineLayer

@export var antialias: bool = true
@export var snap_half_px_for_thin_strokes := true

@onready var renderer: TerrainRender = get_owner()

var data: TerrainData
var _data_conn := false
var _dirty := true
var _strokes: Array = []

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

func request_rebuild() -> void:
	_dirty = true
	queue_redraw()

func _on_data_changed() -> void:
	queue_redraw()

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_redraw()

func _draw() -> void:
	if data == null: return
	if _dirty:
		_rebuild_strokes()

	# Draw outlines first (z sorted inside)
	for S in _strokes:
		if S.color.a <= 0.0: continue
		if S.width <= 0.0: continue
		for chain in S.chains:
			match S.mode:
				TerrainBrush.DrawMode.SOLID:  _draw_polyline_solid(chain, S.color, S.width)
				TerrainBrush.DrawMode.DASHED: _draw_polyline_dashed(chain, S.color, S.width, S.dash, S.gap)
				TerrainBrush.DrawMode.DOTTED: _draw_polyline_dotted(chain, S.color, S.width, max(2.0, S.gap))
				_:                            _draw_polyline_solid(chain, S.color, S.width)

## Rebuild lines
func _rebuild_strokes() -> void:
	_dirty = false
	_strokes.clear()
	if data == null or data.lines == null or data.lines.is_empty(): return

	var outlines: Array = []
	var cores: Array = []

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

		var chain_outline := safe_pts
		var chain_core := safe_pts
		if snap_half_px_for_thin_strokes and (int(round(core_w + 2.0 * stroke_w)) % 2 != 0):
			chain_outline = _offset_half_px(chain_outline)
		if snap_half_px_for_thin_strokes and (int(round(core_w)) % 2 != 0):
			chain_core = _offset_half_px(chain_core)

		outlines.append({
			"mode": mode, "color": stroke_col, "width": core_w + 2.0 * stroke_w,
			"chains": [chain_outline], "z": brush.z_index,
			"dash": float(rec.stroke.dash_px if rec.has("stroke") and "dash_px" in rec.stroke else 8.0),
			"gap":  float(rec.stroke.gap_px  if rec.has("stroke") and "gap_px"  in rec.stroke else 6.0)
		})
		cores.append({
			"mode": mode, "color": fill_col, "width": core_w,
			"chains": [chain_core], "z": brush.z_index,
			"dash": float(rec.stroke.dash_px if rec.has("stroke") and "dash_px" in rec.stroke else 8.0),
			"gap":  float(rec.stroke.gap_px  if rec.has("stroke") and "gap_px"  in rec.stroke else 6.0)
		})

	outlines.sort_custom(func(a,b): return int(a.z) < int(b.z))
	cores.sort_custom(func(a,b): return int(a.z) < int(b.z))
	_strokes.append_array(outlines)
	_strokes.append_array(cores)

func _offset_half_px(pts: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in pts: out.append(p + Vector2(0.5, 0.5))
	return out

func _draw_polyline_solid(pts: PackedVector2Array, color: Color, width: float) -> void:
	if pts.size() < 2: return
	draw_polyline(pts, color, width, antialias)

## Draw dashed line
func _draw_polyline_dashed(pts: PackedVector2Array, color: Color, width: float, dash_px: float, gap_px: float) -> void:
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
func _draw_polyline_dotted(pts: PackedVector2Array, color: Color, width: float, step_px: float) -> void:
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
