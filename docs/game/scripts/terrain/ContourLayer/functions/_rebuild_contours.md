# ContourLayer::_rebuild_contours Function Reference

*Defined at:* `scripts/terrain/ContourLayer.gd` (lines 204–258)</br>
*Belongs to:* [ContourLayer](../../ContourLayer.md)

**Signature**

```gdscript
func _rebuild_contours() -> void
```

## Description

Rebuild the contour lines

## Source

```gdscript
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
	var dh := float(max(1, data.contour_interval_m))

	var min_e := INF
	var max_e := -INF
	for y in h:
		for x in w:
			var e := img.get_pixel(x, y).r
			if e < min_e:
				min_e = e
			if e > max_e:
				max_e = e

	var base := _get_base_offset()
	var start_level: float = floor((min_e + base) / dh) * dh - base
	var level := start_level
	while level <= max_e + 0.0001:
		_levels.append(level)
		level += dh

	for l in _levels:
		var segments := _march_level_segments(img, w, h, step_m, l)
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
			_polylines_by_level[l] = smoothed
		else:
			_polylines_by_level[l] = polylines
```
