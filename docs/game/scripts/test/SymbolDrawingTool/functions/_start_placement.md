# SymbolDrawingTool::_start_placement Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 114–129)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _start_placement(pos: Vector2) -> void
```

## Description

Start placing a new shape

## Source

```gdscript
func _start_placement(pos: Vector2) -> void:
	# Check if clicking on existing shape to select it
	for shape in _shapes:
		if shape.is_point_near(pos):
			_selected_shape = shape
			_is_dragging = true
			_drag_start = pos
			canvas.queue_redraw()
			return

	# Start new shape
	_selected_shape = null
	_is_placing = true
	_current_shape = Shape.new(_current_tool, pos, pos, _current_filled, _current_corner_radius)
```
