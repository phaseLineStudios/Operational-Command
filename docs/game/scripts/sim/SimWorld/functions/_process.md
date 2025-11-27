# SimWorld::_process Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 199–210)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _process(dt: float) -> void
```

- **dt**: Frame delta seconds.

## Description

Fixed-rate loop; advances the sim in discrete ticks while RUNNING.

## Source

```gdscript
func _process(dt: float) -> void:
	if _state != State.RUNNING:
		if _state == State.PAUSED:
			_process_orders()
			trigger_engine.tick(dt)
		return
	_dt_accum += dt * _time_scale
	while _dt_accum >= _tick_dt:
		_step_tick(_tick_dt)
		_dt_accum -= _tick_dt
```
