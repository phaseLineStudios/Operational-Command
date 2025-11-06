# MilSymbolRenderer::_draw_unique_designation Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolRenderer.gd` (lines 374–391)</br>
*Belongs to:* [MilSymbolRenderer](../../MilSymbolRenderer.md)

**Signature**

```gdscript
func _draw_unique_designation() -> void
```

## Description

Draw unique designation below the frame

## Source

```gdscript
func _draw_unique_designation() -> void:
	var bounds := MilSymbolGeometry.get_frame_bounds(domain, affiliation)
	var pos := Vector2(
		bounds.position.x + bounds.size.x / 2, bounds.position.y + bounds.size.y + 20
	)

	var font_size := int(config.font_size * 0.6)
	draw_string(
		ThemeDB.fallback_font,
		pos,
		unique_designation,
		HORIZONTAL_ALIGNMENT_CENTER,
		-1,
		font_size,
		config.text_color
	)
```
