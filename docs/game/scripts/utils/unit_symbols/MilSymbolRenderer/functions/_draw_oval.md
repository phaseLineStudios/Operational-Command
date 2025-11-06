# MilSymbolRenderer::_draw_oval Function Reference

*Defined at:* `scripts/utils/unit_symbols/MilSymbolRenderer.gd` (lines 303–322)</br>
*Belongs to:* [MilSymbolRenderer](../../MilSymbolRenderer.md)

**Signature**

```gdscript
func _draw_oval(rect: Rect2, color: Color, filled: bool) -> void
```

## Description

Draw an oval (ellipse) from rect

## Source

```gdscript
func _draw_oval(rect: Rect2, color: Color, filled: bool) -> void:
	var center := rect.get_center()
	var rx := rect.size.x / 2.0
	var ry := rect.size.y / 2.0
	var segments := 32

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
