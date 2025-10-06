# MarginLayer::apply_style Function Reference

*Defined at:* `scripts/terrain/MapMargin.gd` (lines 57–99)</br>
*Belongs to:* [MarginLayer](../MarginLayer.md)

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
	if "title_size" in from:
		title_size = from.title_size
	if "margin_color" in from:
		margin_color = from.margin_color
	if "margin_top_px" in from:
		margin_top_px = from.margin_top_px
	if "margin_bottom_px" in from:
		margin_bottom_px = from.margin_bottom_px
	if "margin_left_px" in from:
		margin_left_px = from.margin_left_px
	if "margin_right_px" in from:
		margin_right_px = from.margin_right_px
	if "margin_label_every_m" in from:
		margin_label_every_m = from.margin_label_every_m
	if "label_color" in from:
		label_color = from.label_color
	if "label_font" in from:
		label_font = from.label_font
	if "label_size" in from:
		label_size = from.label_size
	if "show_top" in from:
		show_top = from.show_top
	if "show_bottom" in from:
		show_bottom = from.show_bottom
	if "show_left" in from:
		show_left = from.show_left
	if "show_right" in from:
		show_right = from.show_right
	if "base_border_px" in from:
		base_border_px = from.base_border_px
	if "offset_top_px" in from:
		offset_top_px = from.offset_top_px
	if "offset_bottom_px" in from:
		offset_bottom_px = from.offset_bottom_px
	if "offset_left_px" in from:
		offset_left_px = from.offset_left_px
	if "offset_right_px" in from:
		offset_right_px = from.offset_right_px
```
