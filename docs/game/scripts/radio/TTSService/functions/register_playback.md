# TTSService::register_playback Function Reference

*Defined at:* `scripts/radio/TTSService.gd` (lines 119–124)</br>
*Belongs to:* [TTSService](../../TTSService.md)

**Signature**

```gdscript
func register_playback(playback: AudioStreamGeneratorPlayback) -> void
```

- **playback**: The player's stream playback.

## Description

Register the consumer's playback so we can push frames into it.

## Source

```gdscript
func register_playback(playback: AudioStreamGeneratorPlayback) -> void:
	_playback = playback
	_tts.set_playback(_playback)
	LogService.trace("Registered playback.", "TTSService.gd:register_playback")
```
