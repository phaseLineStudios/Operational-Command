# TTSService::register_player Function Reference

*Defined at:* `scripts/radio/TTSService.gd` (lines 127–133)</br>
*Belongs to:* [TTSService](../../TTSService.md)

**Signature**

```gdscript
func register_player(player: AudioStreamPlayer) -> void
```

- **player**: The player to register for playback.

## Description

Register by passing the player's node (sets stream & plays).

## Source

```gdscript
func register_player(player: AudioStreamPlayer) -> void:
	player.stream = _gen
	player.play()
	LogService.trace("Registered player.", "TTSService.gd:register_player")
	register_playback(player.get_stream_playback() as AudioStreamGeneratorPlayback)
```
