# TimerController::_set_time_state Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 296–302)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _set_time_state(state: TimeState) -> void
```

## Description

Set the time state and apply it.

## Source

```gdscript
func _set_time_state(state: TimeState) -> void:
	if _current_state == state:
		return
	_current_state = state
	_apply_time_state(state)
```
