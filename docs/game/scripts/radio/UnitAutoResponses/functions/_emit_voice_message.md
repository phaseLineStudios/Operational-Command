# UnitAutoResponses::_emit_voice_message Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 383–389)</br>
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
	if TTSService:
		TTSService.say(formatted)
	LogService.debug("Unit voice: %s" % formatted, "UnitAutoResponses.gd")
```
