# SymbolDrawingTool::_draw_filled_circle_on_canvas Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 236–244)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _draw_filled_circle_on_canvas(center: Vector2, radius: float, color: Color) -> void
```

## Description

Draw filled circle on canvas

## Source

```gdscript
func _draw_filled_circle_on_canvas(center: Vector2, radius: float, color: Color) -> void:
	var points := PackedVector2Array()
	for angle_deg in range(0, 360, 5):
		var angle := deg_to_rad(angle_deg)
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	if points.size() > 0:
		canvas.draw_colored_polygon(points, color)
```
