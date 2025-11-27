# TriggerAPI::radio Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 73–77)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func radio(msg: String, level: String = "info") -> void
```

- **msg**: Radio message.
- **level**: Optional Log level.

## Description

Send a radio/log message (levels: info|warn|error).

## Source

```gdscript
func radio(msg: String, level: String = "info") -> void:
	if sim:
		sim.emit_signal("radio_message", level, msg)
```
