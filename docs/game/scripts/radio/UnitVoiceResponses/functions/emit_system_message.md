# UnitVoiceResponses::emit_system_message Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 484–491)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func emit_system_message(message: String, callsign: String = "Mission Control") -> void
```

- **message**: Message text to speak.
- **callsign**: Optional callsign (defaults to "Mission Control").

## Description

Emit a system message (e.g., from TriggerAPI) with radio SFX.

## Source

```gdscript
func emit_system_message(message: String, callsign: String = "Mission Control") -> void:
	_current_transmitter = callsign
	transmission_start.emit(callsign)

	if TTSService:
		TTSService.say(message)

	unit_response.emit(callsign, message)
```
