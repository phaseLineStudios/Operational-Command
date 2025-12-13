# EnvSoundController::_rain_level_from_mm Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 204–211)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func _rain_level_from_mm(rain_mm: float) -> int
```

## Description

Map rain mm/h to 0 (none), 1 (light), 2 (heavy).

## Source

```gdscript
func _rain_level_from_mm(rain_mm: float) -> int:
	if rain_mm < 0.1:
		return 0
	if rain_mm < 4.0:
		return 1
	return 2
```
