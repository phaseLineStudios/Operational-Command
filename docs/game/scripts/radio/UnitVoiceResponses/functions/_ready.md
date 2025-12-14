# UnitVoiceResponses::_ready Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 34–47)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_load_acknowledgments()

	if TTSService:
		TTSService.speaking_finished.connect(_on_tts_finished)

	if auto_responses:
		auto_responses.unit_auto_response.connect(_on_auto_response)
		auto_responses.transmission_start.connect(_on_auto_transmission_start)
		auto_responses.transmission_end_requested.connect(_on_auto_transmission_end_requested)
	else:
		push_warning("UnitVoiceResponses: UnitAutoResponses not found.")
```
