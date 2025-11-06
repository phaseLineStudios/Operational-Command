# EnvironmentController::_update_time Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 47–52)</br>
*Belongs to:* [EnvironmentController](../../EnvironmentController.md)

**Signature**

```gdscript
func _update_time(dt: float) -> void
```

## Description

Check if simulating day/night cycle, determine rate of time, and increase time

## Source

```gdscript
func _update_time(dt: float) -> void:
	time_of_day += dt
	if time_of_day > 86400.0:
		time_of_day = 0.0
```
