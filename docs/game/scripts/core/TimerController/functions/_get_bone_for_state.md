# TimerController::_get_bone_for_state Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 341–351)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _get_bone_for_state(state: TimeState) -> int
```

## Description

Get the bone index for a time state.

## Source

```gdscript
func _get_bone_for_state(state: TimeState) -> int:
	match state:
		TimeState.PAUSED:
			return _pause_bone_idx
		TimeState.SPEED_1X:
			return _speed_1x_bone_idx
		TimeState.SPEED_2X:
			return _speed_2x_bone_idx
	return -1
```
