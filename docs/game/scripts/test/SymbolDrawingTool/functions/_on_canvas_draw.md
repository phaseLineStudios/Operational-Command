# SymbolDrawingTool::_on_canvas_draw Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 151–189)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _on_canvas_draw() -> void
```

## Description

Draw canvas with grid, shapes, and guides

## Source

```gdscript
func _on_canvas_draw() -> void:
	# Draw background
	canvas.draw_rect(Rect2(0, 0, CANVAS_SIZE, CANVAS_SIZE), Color(0.95, 0.95, 0.95))

	# Draw grid
	var grid_color := Color(0.8, 0.8, 0.8, 0.5)
	for i in range(0, CANVAS_SIZE + 1, 24):
		canvas.draw_line(Vector2(i, 0), Vector2(i, CANVAS_SIZE), grid_color, 1.0)
		canvas.draw_line(Vector2(0, i), Vector2(CANVAS_SIZE, i), grid_color, 1.0)

	# Draw center crosshair
	var center := Vector2(CANVAS_SIZE / 2.0, CANVAS_SIZE / 2.0)
	canvas.draw_line(Vector2(center.x, 0), Vector2(center.x, CANVAS_SIZE), Color.RED, 1.5, true)
	canvas.draw_line(Vector2(0, center.y), Vector2(CANVAS_SIZE, center.y), Color.RED, 1.5, true)

	# Draw icon area boundary
	var half_icon := ICON_AREA / 2.0
	canvas.draw_rect(
		Rect2(center.x - half_icon, center.y - half_icon, ICON_AREA, ICON_AREA),
		Color(0.5, 0.8, 1.0, 0.15),
		true
	)
	canvas.draw_rect(
		Rect2(center.x - half_icon, center.y - half_icon, ICON_AREA, ICON_AREA),
		Color(0.3, 0.6, 1.0, 0.6),
		false,
		2.0
	)

	# Draw all completed shapes
	for shape in _shapes:
		var is_selected := shape == _selected_shape
		_draw_shape(shape, is_selected)

	# Draw current shape being placed
	if _is_placing and _current_shape:
		_draw_shape(_current_shape, false, true)
```
