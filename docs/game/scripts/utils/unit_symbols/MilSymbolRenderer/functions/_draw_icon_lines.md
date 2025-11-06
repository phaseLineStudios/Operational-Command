# MilSymbolRenderer::_draw_icon_lines Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolRenderer.gd` (lines 168–173)</br>
*Belongs to:* [MilSymbolRenderer](../../MilSymbolRenderer.md)

**Signature**

```gdscript
func _draw_icon_lines(paths: Array, color: Color) -> void
```

## Description

Draw icon as lines

## Source

```gdscript
func _draw_icon_lines(paths: Array, color: Color) -> void:
	for path in paths:
		if path is Array and path.size() >= 2:
			draw_polyline(path, color, config.stroke_width * 0.75)
```
