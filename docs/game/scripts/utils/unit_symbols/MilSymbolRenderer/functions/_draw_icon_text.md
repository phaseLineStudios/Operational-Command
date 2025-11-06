# MilSymbolRenderer::_draw_icon_text Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolRenderer.gd` (lines 341–355)</br>
*Belongs to:* [MilSymbolRenderer](../../MilSymbolRenderer.md)

**Signature**

```gdscript
func _draw_icon_text(text: String, pos: Vector2, size: int, color: Color) -> void
```

## Description

Draw icon text

## Source

```gdscript
func _draw_icon_text(text: String, pos: Vector2, size: int, color: Color) -> void:
	# Note: For proper text rendering, you'd want to use a Font resource
	# For now, we'll use draw_string with default font
	var font_size := int(size * scale_factor)
	draw_string(
		ThemeDB.fallback_font,
		pos - Vector2(size * 0.5, -size * 0.25),
		text,
		HORIZONTAL_ALIGNMENT_CENTER,
		-1,
		font_size,
		color
	)
```
