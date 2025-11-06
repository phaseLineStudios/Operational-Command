# SymbolDrawingTool::_draw_filled_ellipse_on_canvas Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 259–267)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _draw_filled_ellipse_on_canvas(center: Vector2, rx: float, ry: float, color: Color) -> void
```

## Description

Draw filled ellipse on canvas

## Source

```gdscript
func _draw_filled_ellipse_on_canvas(center: Vector2, rx: float, ry: float, color: Color) -> void:
	var points := PackedVector2Array()
	for angle_deg in range(0, 360, 5):
		var angle := deg_to_rad(angle_deg)
		points.append(center + Vector2(cos(angle) * rx, sin(angle) * ry))
	if points.size() > 0:
		canvas.draw_colored_polygon(points, color)
```
