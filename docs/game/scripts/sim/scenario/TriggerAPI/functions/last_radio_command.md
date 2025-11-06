# TriggerAPI::last_radio_command Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 155–158)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func last_radio_command() -> String
```

- **Return Value**: Last radio command text (lowercase, normalized).

## Description

Get the last radio command heard this tick (cleared after tick).
Useful for trigger conditions to match custom voice commands.
  
  

**Usage in trigger condition_expr:**

```
last_radio_command().contains("fire mission")
last_radio_command() == "thunder actual"
```

  

**Note:** Command is automatically cleared after each tick, so triggers
only fire once per voice command.

## Source

```gdscript
func last_radio_command() -> String:
	return _last_radio_command
```
