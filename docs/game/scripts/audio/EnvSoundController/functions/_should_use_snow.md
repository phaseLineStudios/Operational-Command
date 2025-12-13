# EnvSoundController::_should_use_snow Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 222–231)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func _should_use_snow(scenario: ScenarioData) -> bool
```

## Description

Simple heuristic: use snow in winter months if snow sounds exist.

## Source

```gdscript
func _should_use_snow(scenario: ScenarioData) -> bool:
	if sound_snow.is_empty():
		return false

	if scenario.month == 12 or scenario.month == 1 or scenario.month == 2:
		return scenario.rain > 0.1

	return false
```
