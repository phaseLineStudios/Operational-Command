# UnitVoiceResponses::_ready Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 74–80)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	# Reference the TTS autoload
	tts_service = get_node_or_null("/root/TTSService")
	if not tts_service:
		push_warning("UnitVoiceResponses: TTSService autoload not found.")
```
