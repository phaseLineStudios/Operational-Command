# SymbolDrawingTool::_input Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 90–107)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _input(event: InputEvent) -> void
```

## Description

Handle mouse input for placing/editing shapes

## Source

```gdscript
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var local_pos := canvas.get_local_mouse_position()
			if _is_point_in_canvas(local_pos):
				if event.pressed:
					_start_placement(local_pos)
				else:
					_end_placement()
				get_viewport().set_input_as_handled()

	elif event is InputEventMouseMotion:
		var local_pos := canvas.get_local_mouse_position()
		if _is_placing and _is_point_in_canvas(local_pos):
			_update_placement(local_pos)
			canvas.queue_redraw()
```
