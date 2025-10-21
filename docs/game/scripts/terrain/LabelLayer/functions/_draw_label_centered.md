# LabelLayer::_draw_label_centered Function Reference

*Defined at:* `scripts/terrain/LabelLayer.gd` (lines 200–246)</br>
*Belongs to:* [LabelLayer](../../LabelLayer.md)

**Signature**

```gdscript
func _draw_label_centered(pos_local: Vector2, text: String, font_size: int, rot_deg: float) -> void
```

## Description

Draw a centered label with a robust outline (multi-offset fallback)

## Source

```gdscript
func _draw_label_centered(pos_local: Vector2, text: String, font_size: int, rot_deg: float) -> void:
	var s_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var ascent := font.get_ascent(font_size)
	var height := font.get_height(font_size)
	var baseline_local := Vector2(-s_size.x * 0.5, -height * 0.5 + ascent)
	var ang := deg_to_rad(rot_deg)

	draw_set_transform(pos_local, ang, Vector2.ONE)

	if outline_size > 0 and outline_color.a > 0.0:
		draw_string_outline(
			font,
			baseline_local,
			text,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			font_size,
			outline_size,
			outline_color
		)

		var r: int = max(1, int(outline_size))
		var offsets := [
			Vector2(-r, 0),
			Vector2(r, 0),
			Vector2(0, -r),
			Vector2(0, r),
			Vector2(-r, -r),
			Vector2(-r, r),
			Vector2(r, -r),
			Vector2(r, r)
		]
		for o in offsets:
			draw_string(
				font,
				baseline_local + o,
				text,
				HORIZONTAL_ALIGNMENT_LEFT,
				-1,
				font_size,
				outline_color
			)

	draw_string(font, baseline_local, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, text_color)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
```
