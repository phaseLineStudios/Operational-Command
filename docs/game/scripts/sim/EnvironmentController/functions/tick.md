# EnvironmentController::tick Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 150–156)</br>
*Belongs to:* [EnvironmentController](../../EnvironmentController.md)

**Signature**

```gdscript
func tick(dt: float) -> void
```

- **dt**: Delta time since last tick

## Description

Tick time

## Source

```gdscript
func tick(dt: float) -> void:
	_update_time(dt)
	_update_rotation()
	_update_sky()
	_update_lights()
```
