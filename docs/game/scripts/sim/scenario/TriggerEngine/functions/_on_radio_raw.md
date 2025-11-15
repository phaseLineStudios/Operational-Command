# TriggerEngine::_on_radio_raw Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 297–301)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func _on_radio_raw(text: String) -> void
```

## Description

Handle raw radio command from Radio node.

## Source

```gdscript
func _on_radio_raw(text: String) -> void:
	_last_radio_text = text
	_api._set_last_radio_command(text)
```
