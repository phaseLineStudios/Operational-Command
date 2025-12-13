# UnitVoiceResponses::_on_tts_finished Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 475–480)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _on_tts_finished() -> void
```

## Description

Handle TTS audio playback finished.
Emits transmission_end for the current transmitter.

## Source

```gdscript
func _on_tts_finished() -> void:
	if _current_transmitter != "":
		transmission_end.emit(_current_transmitter)
		_current_transmitter = ""
```
