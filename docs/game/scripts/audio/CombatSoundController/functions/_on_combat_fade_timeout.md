# CombatSoundController::_on_combat_fade_timeout Function Reference

*Defined at:* `scripts/audio/CombatSoundController.gd` (lines 73–77)</br>
*Belongs to:* [CombatSoundController](../../CombatSoundController.md)

**Signature**

```gdscript
func _on_combat_fade_timeout() -> void
```

## Description

Called when combat fade timer times out.

## Source

```gdscript
func _on_combat_fade_timeout() -> void:
	if _combat_sound_playing:
		_stop_combat_sound_loop()
```
