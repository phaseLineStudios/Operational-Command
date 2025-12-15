# TriggerAPI::triggering_units_enemy Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 219–224)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func triggering_units_enemy() -> Array
```

- **Return Value**: Array of enemy unit IDs in trigger area, or empty array if not called from trigger.

## Description

Get list of enemy unit IDs currently inside the trigger area.
Only works when called from within a trigger condition or action expression.

## Source

```gdscript
func triggering_units_enemy() -> Array:
	if _current_context.has("units_enemy"):
		return _current_context.get("units_enemy", [])
	return []
```
