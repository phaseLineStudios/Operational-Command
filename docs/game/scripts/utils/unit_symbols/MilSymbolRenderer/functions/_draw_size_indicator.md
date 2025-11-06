# MilSymbolRenderer::_draw_size_indicator Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolRenderer.gd` (lines 357–372)</br>
*Belongs to:* [MilSymbolRenderer](../../MilSymbolRenderer.md)

**Signature**

```gdscript
func _draw_size_indicator() -> void
```

## Description

Draw size/echelon indicator above the frame

## Source

```gdscript
func _draw_size_indicator() -> void:
	var bounds := MilSymbolGeometry.get_frame_bounds(domain, affiliation)
	var pos := Vector2(bounds.position.x, bounds.position.y - 10)

	var font_size := int(config.font_size * 0.8)
	draw_string(
		ThemeDB.fallback_font,
		pos,
		unit_size_text,
		HORIZONTAL_ALIGNMENT_CENTER,
		bounds.size.x,
		font_size,
		config.text_color
	)
```
