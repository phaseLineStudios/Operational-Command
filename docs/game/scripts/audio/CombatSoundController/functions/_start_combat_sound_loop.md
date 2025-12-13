# CombatSoundController::_start_combat_sound_loop Function Reference

*Defined at:* `scripts/audio/CombatSoundController.gd` (lines 79–87)</br>
*Belongs to:* [CombatSoundController](../../CombatSoundController.md)

**Signature**

```gdscript
func _start_combat_sound_loop() -> void
```

## Description

Start playing looping combat sound.

## Source

```gdscript
func _start_combat_sound_loop() -> void:
	var sfx := _pick_random_stream(sound_distant_combat)
	if sfx:
		_sfx_combat.stream = sfx
		_sfx_combat.play()
		_combat_sound_playing = true
		LogService.debug("Started distant combat sound loop", "CombatSoundController")
```
