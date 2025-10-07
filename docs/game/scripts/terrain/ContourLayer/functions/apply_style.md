# ContourLayer::apply_style Function Reference

*Defined at:* `scripts/terrain/ContourLayer.gd` (lines 79–114)</br>
*Belongs to:* [ContourLayer](../../ContourLayer.md)

**Signature**

```gdscript
func apply_style(from: Node) -> void
```

## Description

Apply root style

## Source

```gdscript
func apply_style(from: Node) -> void:
	if from == null:
		return
	if "contour_color" in from:
		contour_color = from.contour_color
	if "contour_thick_color" in from:
		contour_thick_color = from.contour_thick_color
	if "contour_px" in from:
		contour_px = from.contour_px
	if "contour_thick_every_m" in from:
		contour_thick_every_m = from.contour_thick_every_m
	if "smooth_iterations" in from:
		smooth_iterations = from.smooth_iterations
	if "smooth_segment_len_m" in from:
		smooth_segment_len_m = from.smooth_segment_len_m
	if "smooth_keep_ends" in from:
		smooth_keep_ends = from.smooth_keep_ends
	if "contour_label_every_m" in from:
		contour_label_every_m = from.contour_label_every_m
	if "contour_label_on_thick_only" in from:
		contour_label_on_thick_only = from.contour_label_on_thick_only
	if "contour_label_color" in from:
		contour_label_color = from.contour_label_color
	if "contour_label_bg" in from:
		contour_label_bg = from.contour_label_bg
	if "contour_label_padding_px" in from:
		contour_label_padding_px = from.contour_label_padding_px
	if "contour_label_font" in from:
		contour_label_font = from.contour_label_font
	if "contour_label_size" in from:
		contour_label_size = from.contour_label_size
	if "contour_label_gap_extra_px" in from:
		contour_label_gap_extra_px = from.contour_label_gap_extra_px
	mark_dirty()
```
