# EnvSoundController::_wind_level_from_speed Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 213–220)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func _wind_level_from_speed(speed_m: float) -> int
```

## Description

Map wind speed m/s to 0 (none), 1 (light), 2 (heavy).

## Source

```gdscript
func _wind_level_from_speed(speed_m: float) -> int:
	if speed_m < 2.0:
		return 0
	if speed_m < 8.0:
		return 1
	return 2
```
