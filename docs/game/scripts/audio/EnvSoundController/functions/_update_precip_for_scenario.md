# EnvSoundController::_update_precip_for_scenario Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 160–181)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func _update_precip_for_scenario() -> void
```

## Description

Update precipitation (rain/snow) loop.

## Source

```gdscript
func _update_precip_for_scenario() -> void:
	var rain_level := _rain_level_from_mm(_scenario.rain)
	var use_snow := _should_use_snow(_scenario)

	_has_snow = use_snow
	_has_rain = rain_level > 0 and not use_snow

	var stream: AudioStream = null

	if use_snow:
		stream = _pick_random_stream(sound_snow)
	elif rain_level == 1:
		stream = _pick_random_stream(sound_rain_light)
	elif rain_level >= 2:
		stream = _pick_random_stream(sound_rain_heavy)

	if stream == null:
		_stop_precip()
	else:
		_crossfade_precip(stream)
```
