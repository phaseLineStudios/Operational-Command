# DrawingController::_input Function Reference

*Defined at:* `scripts/core/DrawingController.gd` (lines 112–125)</br>
*Belongs to:* [DrawingController](../../DrawingController.md)

**Signature**

```gdscript
func _input(event: InputEvent) -> void
```

## Source

```gdscript
func _input(event: InputEvent) -> void:
	if _current_tool == Tool.NONE:
		return

	if interaction and interaction._held and interaction._held.is_inspecting():
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_drawing()
		else:
			_end_drawing()
```
