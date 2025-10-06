# ContourLayer::_draw_labels_for_placements Function Reference

*Defined at:* `scripts/terrain/ContourLayer.gd` (lines 633–659)</br>
*Belongs to:* [ContourLayer](../ContourLayer.md)

**Signature**

```gdscript
func _draw_labels_for_placements(placements: Array, text: String) -> void
```

## Description

Draw the text plaques using precomputed placements

## Source

```gdscript
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
		var rot: float = p.rot
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
```
