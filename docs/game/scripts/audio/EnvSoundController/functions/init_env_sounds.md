# EnvSoundController::init_env_sounds Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 89–94)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func init_env_sounds(scenario: ScenarioData) -> void
```

## Description

Initialize environment sound controller.

## Source

```gdscript
func init_env_sounds(scenario: ScenarioData) -> void:
	_scenario = scenario
	_update_ambient_for_scenario(_scenario.hour)
	_update_weather_for_scenario()
```
