# EnvSoundController::set_weather Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 102–111)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func set_weather(rain_mm_per_hour: float, wind_speed_m: float, use_snow: bool = false) -> void
```

## Description

Manually update weather ambience from numeric values.

## Source

```gdscript
func set_weather(rain_mm_per_hour: float, wind_speed_m: float, use_snow: bool = false) -> void:
	if _scenario == null:
		_scenario = ScenarioData.new()
	_scenario.rain = rain_mm_per_hour
	_scenario.wind_speed_m = wind_speed_m
	_scenario.month = _scenario.month
	_has_snow = use_snow
	_update_weather_for_scenario()
```
