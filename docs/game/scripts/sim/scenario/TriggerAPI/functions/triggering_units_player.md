# TriggerAPI::triggering_units_player Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 228–233)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func triggering_units_player() -> Array
```

- **Return Value**: Array of player unit IDs in trigger area, or empty array if not called from trigger.

## Description

Get list of player-controlled unit IDs currently inside the trigger area.
Only works when called from within a trigger condition or action expression.

## Source

```gdscript
func triggering_units_player() -> Array:
	if _current_context.has("units_player"):
		return _current_context.get("units_player", [])
	return []
```
