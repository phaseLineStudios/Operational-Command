# MarginLayer::_draw_text_center Function Reference

*Defined at:* `scripts/terrain/MapMargin.gd` (lines 196–209)</br>
*Belongs to:* [MarginLayer](../../MarginLayer.md)

**Signature**

```gdscript
func _draw_text_center(text: String, pos: Vector2, font_size: int = label_size) -> void
```

## Description

Helper function to draw horizontally centered text

## Source

```gdscript
func _draw_text_center(text: String, pos: Vector2, font_size: int = label_size) -> void:
	var s := font_size
	var fm := label_font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, s)
	draw_string(
		label_font,
		pos - Vector2(fm.x * 0.5, 0),
		text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		s,
		label_color
	)
```
