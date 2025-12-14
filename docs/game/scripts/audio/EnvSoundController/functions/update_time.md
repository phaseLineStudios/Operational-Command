# EnvSoundController::update_time Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 96–100)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func update_time(seconds: int) -> void
```

## Description

Manually update ambience from an hour-of-day value.

## Source

```gdscript
func update_time(seconds: int) -> void:
	var hour := int(seconds / 3600.0)
	_update_ambient_for_scenario(hour)
```
