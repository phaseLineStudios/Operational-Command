# EnvSoundController::_stop_precip Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 233–243)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func _stop_precip() -> void
```

## Description

Stop precipitation ambience.

## Source

```gdscript
func _stop_precip() -> void:
	_precip_a.stop()
	_precip_b.stop()
	_precip_a.stream = null
	_precip_b.stream = null
	_precip_a.volume_db = 0.0
	_precip_b.volume_db = 0.0
	_has_rain = false
	_has_snow = false
```
