# CombatSoundController::_stop_combat_sound_loop Function Reference

*Defined at:* `scripts/audio/CombatSoundController.gd` (lines 89–95)</br>
*Belongs to:* [CombatSoundController](../../CombatSoundController.md)

**Signature**

```gdscript
func _stop_combat_sound_loop() -> void
```

## Description

Stop playing combat sound loop.

## Source

```gdscript
func _stop_combat_sound_loop() -> void:
	if _sfx_combat.playing:
		_sfx_combat.stop()
	_combat_sound_playing = false
	LogService.debug("Stopped distant combat sound loop", "CombatSoundController")
```
