# HQTable::_on_radio_message Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 241–255)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _on_radio_message(_level: String, text: String) -> void
```

## Description

Handle radio messages from SimWorld (trigger API, ammo/fuel warnings, etc.)

## Source

```gdscript
func _on_radio_message(_level: String, text: String) -> void:
	# Skip "Order applied" and "Order failed" messages
	# These are already handled by UnitVoiceResponses
	if text.begins_with("Order applied") or text.begins_with("Order failed"):
		return

	# Skip ammo/fuel warnings - now handled by UnitAutoResponses
	if text.contains("low ammo") or text.contains("winchester") or text.contains("low on fuel"):
		return

	# Speak the message via TTS
	if TTSService and TTSService.is_ready():
		TTSService.say(text)
```
