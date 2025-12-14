# UnitVoiceResponses::_on_auto_response Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 454–457)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _on_auto_response(callsign: String, message: String) -> void
```

- **callsign**: Unit callsign.
- **message**: Response message.

## Description

Handle automatic voice response from UnitAutoResponses.
Re-emits as a unit_response for logging/transcript.

## Source

```gdscript
func _on_auto_response(callsign: String, message: String) -> void:
	unit_response.emit(callsign, message)
```
