# ContourLayer::_draw Function Reference

*Defined at:* `scripts/terrain/ContourLayer.gd` (lines 154–202)</br>
*Belongs to:* [ContourLayer](../../ContourLayer.md)

**Signature**

```gdscript
func _draw() -> void
```

## Source

```gdscript
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
			var ts := contour_label_font.get_string_size(
				label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, contour_label_size
			)
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
```
