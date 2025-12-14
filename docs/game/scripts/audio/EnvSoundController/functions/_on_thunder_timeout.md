# EnvSoundController::_on_thunder_timeout Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 344–374)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func _on_thunder_timeout() -> void
```

## Description

Called when thunder timer times out.

## Source

```gdscript
func _on_thunder_timeout() -> void:
	if not enable_thunder:
		return
	if not _has_rain and not _has_snow:
		# Don't play thunder, but restart timer for when weather changes
		if _thunder_timer:
			var wait_time: float
			if thunder_interval_max > thunder_interval_min:
				wait_time = _rng.randf_range(thunder_interval_min, thunder_interval_max)
			else:
				wait_time = max(thunder_interval_min, 0.1)
			_thunder_timer.start(wait_time)
		return
	if sound_thunder.is_empty():
		return

	var sfx := _pick_random_stream(sound_thunder)
	if sfx != null:
		_sfx_thunder.stream = sfx
		_sfx_thunder.play()

	# Restart timer with new random interval
	if _thunder_timer:
		var wait_time: float
		if thunder_interval_max > thunder_interval_min:
			wait_time = _rng.randf_range(thunder_interval_min, thunder_interval_max)
		else:
			wait_time = max(thunder_interval_min, 0.1)
		_thunder_timer.start(wait_time)
```
