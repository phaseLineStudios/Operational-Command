# CombatSoundController::_on_engagement_reported Function Reference

*Defined at:* `scripts/audio/CombatSoundController.gd` (lines 161–173)</br>
*Belongs to:* [CombatSoundController](../../CombatSoundController.md)

**Signature**

```gdscript
func _on_engagement_reported(_attacker_id: String, _defender_id: String, _damage: float) -> void
```

## Description

Called when units engage in combat.

## Source

```gdscript
func _on_engagement_reported(_attacker_id: String, _defender_id: String, _damage: float) -> void:
	if not enable_combat_sounds:
		return

	# Start combat sound if not already playing
	if not _combat_sound_playing:
		_start_combat_sound_loop()

	# Restart fade timer - combat continues
	if _combat_fade_timer:
		_combat_fade_timer.start(combat_fade_time)
```
