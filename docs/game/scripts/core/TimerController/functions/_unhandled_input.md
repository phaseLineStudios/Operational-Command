# TimerController::_unhandled_input Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 172–176)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _unhandled_input(event: InputEvent) -> void
```

## Source

```gdscript
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_check_button_click(event.position)
```
