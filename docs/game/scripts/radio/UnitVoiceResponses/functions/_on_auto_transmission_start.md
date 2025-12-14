# UnitVoiceResponses::_on_auto_transmission_start Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 460–464)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _on_auto_transmission_start(callsign: String) -> void
```

- **callsign**: Unit callsign.

## Description

Handle transmission start from auto responses.

## Source

```gdscript
func _on_auto_transmission_start(callsign: String) -> void:
	_current_transmitter = callsign
	transmission_start.emit(callsign)
```
