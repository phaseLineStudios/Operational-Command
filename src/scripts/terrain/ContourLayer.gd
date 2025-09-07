extends Control
class_name ContourLayer

## Base contour color
@export var contour_color: Color = Color(0.15, 0.15, 0.15, 0.7)
## Contour color for thick lines
@export var contour_thick_color: Color = Color(0.1, 0.1, 0.1, 0.85)
## Base width for contour lines
@export var contour_px: float = 1.0
## How often should contour lines be thick (in m)
@export var contour_thick_every_m: int = 50
## Smoothing iterations
@export var smooth_iterations: int = 2
## Smoothing segment lengths
@export var smooth_segment_len_m: float = 4.0
## Should smoothing keep ends
@export var smooth_keep_ends: bool = true
## Contour label spacing
@export var contour_label_every_m: int = 200
## Only show elevation label on thick contours
@export var contour_label_on_thick_only: bool = true
## Contour label color
@export var contour_label_color: Color = Color(0.1, 0.1, 0.1, 0.95)
## Contour label background
@export var contour_label_bg: Color = Color(1, 1, 1, 0.85)
## Contour label padding
@export var contour_label_padding_px: float = 3.0
## Contour label font
@export var contour_label_font: Font
## Contour label font size
@export var contour_label_size: int = 12
## Extra space beyond plaque width
@export var contour_label_gap_extra_px: float = 2.0

var data: TerrainData
var _data_conn := false
var _data_conn_elev := false

var _levels: PackedFloat32Array = []
var _polylines_by_level: Dictionary = {}
var _dirty := true

var _rebuild_scheduled := false
@export var rebuild_delay_sec := 0.05

## API to set Terrain Data
func set_data(d: TerrainData) -> void:
	if _data_conn and data and data.is_connected("changed", Callable(self, "_on_data_changed")):
		data.disconnect("changed", Callable(self, "_on_data_changed"))
	if _data_conn_elev and data and data.has_signal("elevation_changed") and data.is_connected("elevation_changed", Callable(self, "_on_elevation_changed")):
		data.disconnect("elevation_changed", Callable(self, "_on_elevation_changed"))
	_data_conn = false
	_data_conn_elev = false

	data = d
	_mark_dirty()

	if data:
		data.changed.connect(_on_data_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED)
		_data_conn = true
		if data.has_signal("elevation_changed"):
			data.elevation_changed.connect(_on_elevation_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED)
			_data_conn_elev = true

	_schedule_rebuild()
	queue_redraw()

## API to apply style exports
func apply_style(from: Node) -> void:
	if from == null: return
	if "contour_color" in from: contour_color = from.contour_color
	if "contour_thick_color" in from: contour_thick_color = from.contour_thick_color
	if "contour_px" in from: contour_px = from.contour_px
	if "contour_thick_every_m" in from: contour_thick_every_m = from.contour_thick_every_m
	if "smooth_iterations" in from: smooth_iterations = from.smooth_iterations
	if "smooth_segment_len_m" in from: smooth_segment_len_m = from.smooth_segment_len_m
	if "smooth_keep_ends" in from: smooth_keep_ends = from.smooth_keep_ends
	if "contour_label_every_m" in from: contour_label_every_m = from.contour_label_every_m
	if "contour_label_on_thick_only" in from: contour_label_on_thick_only = from.contour_label_on_thick_only
	if "contour_label_color" in from: contour_label_color = from.contour_label_color
	if "contour_label_bg" in from: contour_label_bg = from.contour_label_bg
	if "contour_label_padding_px" in from: contour_label_padding_px = from.contour_label_padding_px
	if "contour_label_font" in from: contour_label_font = from.contour_label_font
	if "contour_label_size" in from: contour_label_size = from.contour_label_size
	if "contour_label_gap_extra_px" in from: contour_label_gap_extra_px = from.contour_label_gap_extra_px
	_mark_dirty()
	_schedule_rebuild()

## API to request contour rebuild
func request_rebuild() -> void:
	_mark_dirty()
	_schedule_rebuild()

## Redraw contours on resize
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_redraw()

## Rebuild contours if terrain data changes
func _on_data_changed() -> void:
	_mark_dirty()
	_schedule_rebuild()

## Rebuild contours if elevation data changes
func _on_elevation_changed(_rect := Rect2i(0,0,0,0)) -> void:
	_mark_dirty()
	_schedule_rebuild()

## Mark contours as dirty
func _mark_dirty() -> void:
	_dirty = true

## Schedule a Rebuild of the contour lines
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

func _draw() -> void:
	if data == null:
		return
	if _dirty and not _rebuild_scheduled:
		_rebuild_contours()

	for i in _levels.size():
		var level := _levels[i]
		var polylines: Array = _polylines_by_level.get(level, [])
		if polylines.is_empty():
			continue

		var thick := _is_thick_level_abs(level)
		var col := contour_thick_color if thick else contour_color
		var w: float = max(0.5, (contour_px * 1.6) if thick else contour_px)

		var place_labels := contour_label_font != null and contour_label_every_m > 0
		var label_this_level := true
		if contour_label_on_thick_only:
			label_this_level = _is_thick_level_abs(level)

		var label_text := str(int(round(level + _get_base_offset())))
		var label_rect_size := Vector2.ZERO
		if place_labels and label_this_level:
			var ts := contour_label_font.get_string_size(label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, contour_label_size)
			label_rect_size = ts + Vector2.ONE * (contour_label_padding_px * 2.0)

		for line: PackedVector2Array in polylines:
			if line.size() < 2:
				continue

			var gaps: Array = []
			var placements: Array = []

			if place_labels and label_this_level:
				placements = _layout_labels_on_line(line, float(contour_label_every_m))
				if label_rect_size.x > 0.0:
					var half := (label_rect_size.x * 0.5) + contour_label_gap_extra_px
					for p in placements:
						gaps.append(Vector2(p.s - half, p.s + half))

			_draw_polyline_with_gaps(line, gaps, col, w)
			
			if place_labels and label_this_level:
				_draw_labels_for_placements(placements, label_text)

## Rebuild the contour lines
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

	var min_e := INF
	var max_e := -INF
	for y in h:
		for x in w:
			var e := img.get_pixel(x, y).r
			if e < min_e: min_e = e
			if e > max_e: max_e = e
	
	var base := _get_base_offset() 
	var start_level: float = floor((min_e + base) / dH) * dH - base
	var level := start_level
	while level <= max_e + 0.0001:
		_levels.append(level)
		level += dH

	for L in _levels:
		var segments := _march_level_segments(img, w, h, step_m, L)
		var polylines := _stitch_segments_to_polylines(segments)
		
		if smooth_segment_len_m > 0.0:
			var smoothed: Array = []
			for pl: PackedVector2Array in polylines:
				if pl.size() < 2:
					continue
				var closed := _polyline_is_closed(pl)
				var res := _resample_polyline_equal_step(pl, max(0.5, smooth_segment_len_m), closed)
				var s := res
				for _i in smooth_iterations:
					s = _chaikin_once(s, closed, smooth_keep_ends)
				smoothed.append(s)
			_polylines_by_level[L] = smoothed
		else:
			_polylines_by_level[L] = polylines

## March over segments for a level
func _march_level_segments(img: Image, w: int, h: int, step_m: float, level: float) -> Array:
	var segs: Array = []

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

			var pts := {}

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

## Stitch segments into polylines
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

## Helper function to check for multiple
static func _is_multiple(value: float, step: float) -> bool:
	if step <= 0.0: return false
	var t := value / step
	return abs(t - round(t)) < 1e-4

## Helper to check if polyline is closed
func _polyline_is_closed(pl: PackedVector2Array, eps := 0.01) -> bool:
	if pl.size() < 3: return false
	return pl[0].distance_to(pl[pl.size() - 1]) <= eps

## Resample a polyline to (roughly) uniform segment length 'step'.
func _resample_polyline_equal_step(pl: PackedVector2Array, step: float, closed: bool) -> PackedVector2Array:
	var pts := pl
	var n := pts.size()
	if n < 2: return pts
	
	# Build a list including closing segment if closed
	var total_len := 0.0
	var seg_len := PackedFloat32Array()
	var count := n if not closed else n
	for i in count - 1:
		var a := pts[i]
		var b := pts[(i + 1) % n]
		var L := a.distance_to(b)
		seg_len.append(L)
		total_len += L
	
	if total_len <= step:
		return pts.duplicate()
	
	var out := PackedVector2Array()
	var target := 0.0
	
	# Start point
	out.append(pts[0])
	
	var seg_idx := 0
	var seg_acc := 0.0
	while target + step <= total_len + 1e-5:
		target += step
		# advance along segments to reach 'target'
		while seg_idx < seg_len.size() and seg_acc + seg_len[seg_idx] < target:
			seg_acc += seg_len[seg_idx]
			seg_idx += 1
		if seg_idx >= seg_len.size():
			break
		var a_i := seg_idx
		var a := pts[a_i]
		var b := pts[(a_i + 1) % n]
		var within := target - seg_acc
		var Lseg: float = max(1e-6, seg_len[seg_idx])
		var alpha := within / Lseg
		out.append(a.lerp(b, alpha))
	# End point for open lines
	if not closed:
		var last := pts[n - 1]
		if out[out.size() - 1].distance_to(last) > 1e-5:
			out.append(last)
	else:
		# Ensure closure
		if out.size() > 1 and out[0].distance_to(out[out.size() - 1]) > 1e-5:
			out.append(out[0])
	
	return out

# https://www.cs.unc.edu/~dm/UNC/COMP258/LECTURES/Chaikins-Algorithm.pdf
## One iteration of Chaikin corner cutting.
func _chaikin_once(pl: PackedVector2Array, closed: bool, keep_ends: bool) -> PackedVector2Array:
	var n := pl.size()
	if n < 3:
		return pl.duplicate()
	
	var out := PackedVector2Array()
	
	if closed:
		for i in n:
			var p0 := pl[(i - 1 + n) % n]
			var p1 := pl[i]
			var p2 := pl[(i + 1) % n]
			var Q := p0 * 0.75 + p1 * 0.25
			var R := p1 * 0.75 + p2 * 0.25
			out.append(Q)
			out.append(R)
		# close loop
		if out[0].distance_to(out[out.size() - 1]) > 1e-5:
			out.append(out[0])
	else:
		if keep_ends:
			out.append(pl[0])
		for i in range(1, n - 1):
			var p0 := pl[i - 1]
			var p1 := pl[i]
			var p2 := pl[i + 1]
			var Q := p0 * 0.75 + p1 * 0.25
			var R := p1 * 0.75 + p2 * 0.25
			out.append(Q)
			out.append(R)
		if keep_ends:
			out.append(pl[n - 1])
	return out

## Get base elevation offset
func _get_base_offset() -> float:
	return (data.base_elevation_m if (data and "base_elevation_m" in data) else 0)

## Check if thick level is absolute elevation
func _is_thick_level_abs(level: float) -> bool:
	var step := float(contour_thick_every_m)
	if step <= 0.0: return false
	var abs_elev := level + _get_base_offset()
	var t := abs_elev / step
	return abs(t - round(t)) < 1e-4

## Compute cumulative length, place labels every `spacing` meters.
func _layout_labels_on_line(line: PackedVector2Array, spacing: float) -> Array:
	var out: Array = []
	var min_seg := 1e-6
	spacing = max(1.0, spacing)
	
	var L := PackedFloat32Array()
	L.resize(line.size())
	L[0] = 0.0
	for i in range(1, line.size()):
		L[i] = L[i-1] + line[i-1].distance_to(line[i])

	var total := L[L.size()-1]
	if total < spacing:
		return out

	var next_s := spacing
	var i := 0
	while next_s <= total + 1e-5:
		while i < L.size()-1 and L[i+1] < next_s:
			i += 1
		if i >= L.size()-1: break
		
		var seg_len: float = max(min_seg, line[i].distance_to(line[i+1]))
		var s_on_seg := next_s - L[i]
		var t: float = clamp(s_on_seg / seg_len, 0.0, 1.0)
		var a := line[i]
		var b := line[i+1]
		var pos := a.lerp(b, t)
		var dir := (b - a) / seg_len
		var rot := atan2(dir.y, dir.x)
		var deg := rad_to_deg(rot)
		if deg > 90.0 or deg < -90.0:
			rot += PI
			dir = -dir

		out.append({"s": next_s, "pos": pos, "dir": dir, "rot": rot})
		next_s += spacing
	return out

## Draw polyline while skipping arclength windows in `gaps`.
func _draw_polyline_with_gaps(line: PackedVector2Array, gaps: Array, color: Color, width: float) -> void:
	if line.size() < 2:
		return
	
	var cleaned: Array = []
	for g in gaps:
		var a: int = min(g.x, g.y)
		var b: int = max(g.x, g.y)
		if b - a > 0.5:
			cleaned.append(Vector2(a, b))
	cleaned.sort_custom(func(a, b): return a.x < b.x)

	var merged: Array = []
	for g in cleaned:
		if merged.is_empty() or g.x > merged[merged.size()-1].y:
			merged.append(g)
		else:
			merged[merged.size()-1].y = max(merged[merged.size()-1].y, g.y)

	var s_acc := 0.0
	for i in range(0, line.size() - 1):
		var a := line[i]
		var b := line[i + 1]
		var seg_len := a.distance_to(b)
		if seg_len <= 1e-6:
			continue
		var seg_s0 := s_acc
		var seg_s1 := s_acc + seg_len
		
		var draw_from := seg_s0
		for g in merged:
			if g.y <= seg_s0 or g.x >= seg_s1:
				continue

			var left: float = clamp(g.x, seg_s0, seg_s1)
			if left > draw_from + 1e-3:
				_draw_segment_subrange(a, b, seg_s0, seg_len, draw_from, left, color, width)
			draw_from = max(draw_from, g.y)
			if draw_from >= seg_s1 - 1e-3:
				break
		if draw_from < seg_s1 - 1e-3:
			_draw_segment_subrange(a, b, seg_s0, seg_len, draw_from, seg_s1, color, width)

		s_acc = seg_s1

## Draw subrange of a single segment given absolute arclengths
func _draw_segment_subrange(a: Vector2, b: Vector2, seg_s0: float, seg_len: float, s0: float, s1: float, color: Color, width: float) -> void:
	s0 = clamp(s0, seg_s0, seg_s0 + seg_len)
	s1 = clamp(s1, seg_s0, seg_s0 + seg_len)
	if s1 <= s0: return
	var t0 := (s0 - seg_s0) / seg_len
	var t1 := (s1 - seg_s0) / seg_len
	var p0 := a.lerp(b, t0)
	var p1 := a.lerp(b, t1)
	draw_line(p0, p1, color, width, true)

## Draw the text plaques using precomputed placements
func _draw_labels_for_placements(placements: Array, text: String) -> void:
	if placements.is_empty() or contour_label_font == null:
		return
	var font := contour_label_font
	var fsize := contour_label_size
	var ts := font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, fsize)
	var half := ts * 0.5
	var pad := Vector2(contour_label_padding_px, contour_label_padding_px)
	var rect := Rect2(-half - pad, ts + pad * 2.0)

	for p in placements:
		var pos: Vector2 = p.pos
		var rot: float   = p.rot
		draw_set_transform(pos, rot, Vector2.ONE)
		if contour_label_bg.a > 0.0:
			draw_rect(rect, contour_label_bg, true)
			draw_rect(rect, contour_label_bg.darkened(0.2), false, 1.0, true)
		draw_string(
			font,
			Vector2(-half.x, half.y),
			text,
			HORIZONTAL_ALIGNMENT_CENTER,
			-1,
			fsize,
			contour_label_color
		)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
