# CombatSoundController::_init_polyphonic_player Function Reference

*Defined at:* `scripts/audio/CombatSoundController.gd` (lines 65–71)</br>
*Belongs to:* [CombatSoundController](../../CombatSoundController.md)

**Signature**

```gdscript
func _init_polyphonic_player(player: AudioStreamPlayer, polyphony: int) -> void
```

## Description

Initialize a polyphonic audio stream player.

## Source

```gdscript
func _init_polyphonic_player(player: AudioStreamPlayer, polyphony: int) -> void:
	var stream := AudioStreamPolyphonic.new()
	stream.polyphony = polyphony
	player.stream = stream
	player.play()
```
