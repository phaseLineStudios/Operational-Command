# EnvSoundController::_update_wind_for_scenario Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 183–197)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func _update_wind_for_scenario() -> void
```

## Description

Update wind loop independent of precipitation.

## Source

```gdscript
func _update_wind_for_scenario() -> void:
	var wind_level := _wind_level_from_speed(_scenario.wind_speed_m)
	var stream: AudioStream = null

	if wind_level == 1:
		stream = _pick_random_stream(sound_wind_light)
	elif wind_level >= 2:
		stream = _pick_random_stream(sound_wind_heavy)

	if stream == null:
		_stop_wind()
	else:
		_crossfade_wind(stream)
```
