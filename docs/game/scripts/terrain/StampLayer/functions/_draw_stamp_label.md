# StampLayer::_draw_stamp_label Function Reference

*Defined at:* `scripts/terrain/StampLayer.gd` (lines 79–92)</br>
*Belongs to:* [StampLayer](../../StampLayer.md)

**Signature**

```gdscript
func _draw_stamp_label(text: String, pos_px: Vector2, offset_x: float, color: Color) -> void
```

## Description

Draw label next to stamp.

## Source

```gdscript
func _draw_stamp_label(text: String, pos_px: Vector2, offset_x: float, color: Color) -> void:
	var font := get_theme_default_font()
	var font_size := 24

	# Position label to the right of stamp
	var label_pos := pos_px + Vector2(offset_x + 5, 0)

	# Draw text with slight outline for visibility
	draw_string(
		font, label_pos + Vector2(1, 1), text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color.BLACK
	)
	draw_string(font, label_pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)
```
