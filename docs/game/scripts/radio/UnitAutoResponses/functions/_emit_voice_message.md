# UnitAutoResponses::_emit_voice_message Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 340–353)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _emit_voice_message(msg: VoiceMessage) -> void
```

## Description

Emit voice message via TTSService.

## Source

```gdscript
func _emit_voice_message(msg: VoiceMessage) -> void:
	var formatted := "%s, %s" % [msg.callsign, msg.text]

	# Emit transmission start for sound effects
	transmission_start.emit(msg.callsign)

	if TTSService:
		TTSService.say(formatted)
	unit_auto_response.emit(msg.callsign, formatted)

	# Request transmission end (actual end happens when TTS finishes)
	transmission_end_requested.emit(msg.callsign)
```
