# EnvSoundController::_update_ambient_for_scenario Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 132–149)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func _update_ambient_for_scenario(time: int) -> void
```

## Description

Update day/night ambient loop based on ScenarioData.

## Source

```gdscript
func _update_ambient_for_scenario(time: int) -> void:
	if _scenario == null:
		return

	var is_daytime := _is_day_hour(time)

	if is_daytime == _is_day and _ambient_initialized:
		return

	var list: Array[AudioStream] = sound_ambient_day if is_daytime else sound_ambient_night

	var stream := _pick_random_stream(list)
	_crossfade_ambient(stream)

	_is_day = is_daytime
	_ambient_initialized = stream != null
```
