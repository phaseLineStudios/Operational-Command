# SymbolDrawingTool::_draw_shape Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 191–234)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _draw_shape(shape: Shape, selected: bool, preview := false) -> void
```

## Description

Draw a single shape

## Source

```gdscript
func _draw_shape(shape: Shape, selected: bool, preview := false) -> void:
	var color := Color.BLACK if not preview else Color(0.4, 0.4, 0.4, 0.7)
	var thickness := 3.0 if not selected else 4.0

	match shape.type:
		ShapeType.LINE:
			canvas.draw_line(shape.start, shape.end, color, thickness, true)

		ShapeType.CIRCLE:
			var center := (shape.start + shape.end) / 2.0
			var radius := shape.start.distance_to(shape.end) / 2.0
			if shape.filled:
				_draw_filled_circle_on_canvas(center, radius, color)
			else:
				_draw_circle_outline_on_canvas(center, radius, color, thickness)

		ShapeType.ELLIPSE:
			var center := (shape.start + shape.end) / 2.0
			var rx: float = abs(shape.end.x - shape.start.x) / 2.0
			var ry: float = abs(shape.end.y - shape.start.y) / 2.0
			if shape.filled:
				_draw_filled_ellipse_on_canvas(center, rx, ry, color)
			else:
				_draw_ellipse_outline_on_canvas(center, rx, ry, color, thickness)

		ShapeType.RECTANGLE:
			var rect := shape.get_bounds()
			if shape.corner_radius > 0:
				_draw_rounded_rect_on_canvas(
					rect, shape.corner_radius, color, shape.filled, thickness
				)
			else:
				if shape.filled:
					canvas.draw_rect(rect, color, true)
				else:
					canvas.draw_rect(rect, color, false, thickness)

	# Draw selection handles
	if selected:
		var handle_color := Color(0.2, 0.7, 1.0)
		canvas.draw_circle(shape.start, 4.0, handle_color)
		canvas.draw_circle(shape.end, 4.0, handle_color)
```
