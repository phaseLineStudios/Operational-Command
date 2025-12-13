# EnvSoundController::_stop_wind Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 245–253)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func _stop_wind() -> void
```

## Description

Stop wind ambience.

## Source

```gdscript
func _stop_wind() -> void:
	_wind_a.stop()
	_wind_b.stop()
	_wind_a.stream = null
	_wind_b.stream = null
	_wind_a.volume_db = 0.0
	_wind_b.volume_db = 0.0
```
