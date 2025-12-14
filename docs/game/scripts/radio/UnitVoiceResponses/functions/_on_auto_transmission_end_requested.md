# UnitVoiceResponses::_on_auto_transmission_end_requested Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 468–472)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _on_auto_transmission_end_requested(_callsign: String) -> void
```

- **callsign**: Unit callsign.

## Description

Handle transmission end request from auto responses.
Doesn't emit immediately - waits for TTS to finish.

## Source

```gdscript
func _on_auto_transmission_end_requested(_callsign: String) -> void:
	# Just track who wants to end - actual emission happens when TTS finishes
	pass
```
