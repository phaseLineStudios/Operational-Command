# TriggerAPI::triggering_units_friend Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 210–215)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func triggering_units_friend() -> Array
```

- **Return Value**: Array of friendly unit IDs in trigger area, or empty array if not called from trigger.

## Description

Get list of friendly unit IDs currently inside the trigger area.
Only works when called from within a trigger condition or action expression.

## Source

```gdscript
func triggering_units_friend() -> Array:
	if _current_context.has("units_friend"):
		return _current_context.get("units_friend", [])
	return []
```
