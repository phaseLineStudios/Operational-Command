# EnvSoundController::_update_weather_for_scenario Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 151–158)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func _update_weather_for_scenario() -> void
```

## Description

Update weather loop from ScenarioData weather values.

## Source

```gdscript
func _update_weather_for_scenario() -> void:
	if _scenario == null:
		return

	_update_precip_for_scenario()
	_update_wind_for_scenario()
```
