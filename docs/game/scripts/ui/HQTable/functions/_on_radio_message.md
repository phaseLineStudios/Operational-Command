# HQTable::_on_radio_message Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 288–299)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _on_radio_message(_level: String, text: String, _unit: String = "") -> void
```

## Description

Handle radio messages from SimWorld (trigger API, ammo/fuel warnings, etc.)

## Source

```gdscript
func _on_radio_message(_level: String, text: String, _unit: String = "") -> void:
	if text.begins_with("Order applied") or text.begins_with("Order failed"):
		return

	if text.contains("low ammo") or text.contains("winchester") or text.contains("low on fuel"):
		return

	if unit_voices:
		# Use system message method to get radio SFX
		unit_voices.emit_system_message(text)
```
