# MilSymbolRenderer::_draw_icon Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolRenderer.gd` (lines 127–166)</br>
*Belongs to:* [MilSymbolRenderer](../../MilSymbolRenderer.md)

**Signature**

```gdscript
func _draw_icon() -> void
```

## Description

Draw the unit icon

## Source

```gdscript
func _draw_icon() -> void:
	var icon_data := MilSymbolIcons.get_icon(icon_type, affiliation)
	if icon_data.is_empty():
		return

	var icon_col := config.icon_color

	match icon_data.get("type", ""):
		"lines":
			_draw_icon_lines(icon_data.get("paths", []), icon_col)
		"path":
			_draw_icon_path(icon_data.get("d", ""), icon_col, icon_data.get("filled", false))
		"circle":
			var center: Vector2 = icon_data.get("center", Vector2(100, 100))
			var radius: float = icon_data.get("radius", 10.0)
			var filled: bool = icon_data.get("filled", false)
			if filled:
				draw_circle(center, radius, icon_col)
			else:
				draw_arc(center, radius, 0, TAU, 32, icon_col, config.stroke_width * 0.75)
		"ellipse":
			var center: Vector2 = icon_data.get("center", Vector2(100, 100))
			var rx: float = icon_data.get("rx", 20.0)
			var ry: float = icon_data.get("ry", 10.0)
			var filled: bool = icon_data.get("filled", false)
			_draw_ellipse(center, rx, ry, icon_col, filled)
		"shapes":
			_draw_icon_shapes(icon_data.get("shapes", []), icon_col)
		"mixed":
			_draw_icon_shapes(icon_data.get("shapes", []), icon_col)
			_draw_icon_lines(icon_data.get("paths", []), icon_col)
		"text":
			_draw_icon_text(
				icon_data.get("text", ""),
				icon_data.get("position", Vector2(100, 100)),
				icon_data.get("size", 32),
				icon_col
			)
```
