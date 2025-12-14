# EnvSoundController::_ready Function Reference

*Defined at:* `scripts/audio/EnvSoundController.gd` (lines 65–69)</br>
*Belongs to:* [EnvSoundController](../../EnvSoundController.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Initialize timers and random generator.

## Source

```gdscript
func _ready() -> void:
	_rng.randomize()
	_setup_timers()
```
