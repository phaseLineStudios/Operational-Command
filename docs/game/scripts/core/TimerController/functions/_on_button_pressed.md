# TimerController::_on_button_pressed Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 239–255)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _on_button_pressed(bone_idx: int) -> void
```

## Description

Handle button press.

## Source

```gdscript
func _on_button_pressed(bone_idx: int) -> void:
	if bone_idx == _current_pressed_bone:
		return

	if _current_pressed_bone >= 0:
		_release_button(_current_pressed_bone)

	_set_button_pressed(bone_idx)

	if bone_idx == _pause_bone_idx:
		_set_time_state(TimeState.PAUSED)
	elif bone_idx == _speed_1x_bone_idx:
		_set_time_state(TimeState.SPEED_1X)
	elif bone_idx == _speed_2x_bone_idx:
		_set_time_state(TimeState.SPEED_2X)
```
