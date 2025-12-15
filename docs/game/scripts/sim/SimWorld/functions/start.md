# SimWorld::start Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 505–515)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func start() -> void
```

## Description

Start simulation from INIT state.

## Source

```gdscript
func start() -> void:
	if _state == State.INIT:
		_transition(_state, State.PAUSED)

		var start_s := _scenario.second + _scenario.minute * 60 + _scenario.hour * 60 * 60
		environment_controller.time_of_day = start_s
		environment_controller.wind_direction = _scenario.wind_dir
		environment_controller.wind_speed = _scenario.wind_dir
		environment_controller.rain_intensity = _scenario.rain
```
