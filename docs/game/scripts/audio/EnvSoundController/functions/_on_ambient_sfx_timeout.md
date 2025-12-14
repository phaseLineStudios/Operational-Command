# EnvSoundController::_on_ambient_sfx_timeout Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 324–342)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func _on_ambient_sfx_timeout() -> void
```

## Description

Called when ambient SFX timer times out.

## Source

```gdscript
func _on_ambient_sfx_timeout() -> void:
	if not enable_ambient_sfx or ambient_sfx.is_empty():
		return

	var sfx := _pick_random_stream(ambient_sfx)
	if sfx != null:
		_sfx_ambient.stream = sfx
		_sfx_ambient.play()

	# Restart timer with new random interval
	if _ambient_sfx_timer:
		var wait_time: float
		if ambient_sfx_interval_max > ambient_sfx_interval_min:
			wait_time = _rng.randf_range(ambient_sfx_interval_min, ambient_sfx_interval_max)
		else:
			wait_time = max(ambient_sfx_interval_min, 0.1)
		_ambient_sfx_timer.start(wait_time)
```
