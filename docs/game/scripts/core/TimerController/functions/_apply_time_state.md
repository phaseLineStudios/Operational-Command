# TimerController::_apply_time_state Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 304–318)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _apply_time_state(state: TimeState) -> void
```

## Description

Apply the time state to the sim (not the entire engine).

## Source

```gdscript
func _apply_time_state(state: TimeState) -> void:
	if not sim_world:
		return

	match state:
		TimeState.PAUSED:
			sim_world.pause()
		TimeState.SPEED_1X:
			sim_world.set_time_scale(1.0)
			sim_world.resume()
		TimeState.SPEED_2X:
			sim_world.set_time_scale(2.0)
			sim_world.resume()
```
