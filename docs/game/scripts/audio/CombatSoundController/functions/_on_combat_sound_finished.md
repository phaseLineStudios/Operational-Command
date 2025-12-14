# CombatSoundController::_on_combat_sound_finished Function Reference

*Defined at:* `scripts/audio/CombatSoundController.gd` (lines 97–104)</br>
*Belongs to:* [CombatSoundController](../../CombatSoundController.md)

**Signature**

```gdscript
func _on_combat_sound_finished() -> void
```

## Description

Called when combat sound finishes - restart with new random sound if still in combat.

## Source

```gdscript
func _on_combat_sound_finished() -> void:
	if _combat_sound_playing:
		var sfx := _pick_random_stream(sound_distant_combat)
		if sfx:
			_sfx_combat.stream = sfx
			_sfx_combat.play()
```
