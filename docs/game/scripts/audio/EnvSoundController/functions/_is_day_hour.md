# EnvSoundController::_is_day_hour Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 199–202)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func _is_day_hour(hour: int) -> bool
```

## Description

Returns true if hour is considered daytime.

## Source

```gdscript
func _is_day_hour(hour: int) -> bool:
	return hour >= 6 and hour < 19
```
