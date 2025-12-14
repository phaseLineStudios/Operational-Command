# EnvSoundController::_reset_timers Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 113–130)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func _reset_timers() -> void
```

## Description

Reset random SFX timers to a random offset.

## Source

```gdscript
func _reset_timers() -> void:
	if _ambient_sfx_timer and enable_ambient_sfx and not ambient_sfx.is_empty():
		var wait_time: float
		if ambient_sfx_interval_max > ambient_sfx_interval_min:
			wait_time = _rng.randf_range(ambient_sfx_interval_min, ambient_sfx_interval_max)
		else:
			wait_time = max(ambient_sfx_interval_min, 0.1)
		_ambient_sfx_timer.start(wait_time)

	if _thunder_timer and enable_thunder:
		var wait_time: float
		if thunder_interval_max > thunder_interval_min:
			wait_time = _rng.randf_range(thunder_interval_min, thunder_interval_max)
		else:
			wait_time = max(thunder_interval_min, 0.1)
		_thunder_timer.start(wait_time)
```
