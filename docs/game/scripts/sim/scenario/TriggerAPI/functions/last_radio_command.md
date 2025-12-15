# TriggerAPI::last_radio_command Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 168–171)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func last_radio_command() -> String
```

- **Return Value**: Last radio command text (lowercase, normalized).

## Description

Get the last radio command heard this tick (cleared after tick).
Useful for trigger conditions to match custom voice commands.

## Source

```gdscript
func last_radio_command() -> String:
	return _last_radio_command
```
