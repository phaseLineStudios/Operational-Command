# TriggerAPI::radio Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 76–80)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func radio(msg: String, level: String = "info", unit_say: String = "") -> void
```

- **msg**: Radio message.
- **level**: Optional Log level (info|warn|error).
- **unit**: Optional unit callsign/ID of the speaker (for transcript display).

## Description

Send a radio/log message (levels: info|warn|error).
Optionally specify which unit is speaking for the transcript.

## Source

```gdscript
func radio(msg: String, level: String = "info", unit_say: String = "") -> void:
	if sim:
		sim.emit_signal("radio_message", level, msg, unit_say)
```
