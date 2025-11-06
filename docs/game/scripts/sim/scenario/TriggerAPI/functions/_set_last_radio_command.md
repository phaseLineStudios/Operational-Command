# TriggerAPI::_set_last_radio_command Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 161–164)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func _set_last_radio_command(cmd: String) -> void
```

- **cmd**: Raw command text from Radio.

## Description

Internal: Set the last radio command (called by TriggerEngine).

## Source

```gdscript
func _set_last_radio_command(cmd: String) -> void:
	_last_radio_command = cmd.to_lower().strip_edges()
```
