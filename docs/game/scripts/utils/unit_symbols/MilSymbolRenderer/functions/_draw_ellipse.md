# MilSymbolRenderer::_draw_ellipse Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolRenderer.gd` (lines 324–339)</br>
*Belongs to:* [MilSymbolRenderer](../../MilSymbolRenderer.md)

**Signature**

```gdscript
func _draw_ellipse(center: Vector2, rx: float, ry: float, color: Color, filled: bool) -> void
```

## Description

Draw an ellipse with center and radii

## Source

```gdscript
func _draw_ellipse(center: Vector2, rx: float, ry: float, color: Color, filled: bool) -> void:
	var segments := 64
	var points: PackedVector2Array = PackedVector2Array()

	for i in range(segments + 1):
		var angle := (TAU * i) / segments
		var x := center.x + rx * cos(angle)
		var y := center.y + ry * sin(angle)
		points.append(Vector2(x, y))

	if filled:
		draw_colored_polygon(points, color)
	else:
		draw_polyline(points, color, config.stroke_width * 0.75)
```
