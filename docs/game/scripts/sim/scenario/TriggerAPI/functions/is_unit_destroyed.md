# TriggerAPI::is_unit_destroyed Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 417–423)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func is_unit_destroyed(id_or_callsign: String) -> bool
```

- **id_or_callsign**: Unit ID or callsign to check.
- **Return Value**: True if unit is destroyed/dead, false if alive or not found.

## Description

Check if a unit is destroyed (wiped out, state_strength == 0).
Returns true if the unit is dead or has zero strength.

## Source

```gdscript
func is_unit_destroyed(id_or_callsign: String) -> bool:
	var unit_data := unit(id_or_callsign)
	if unit_data.is_empty():
		return false
	return unit_data.get("dead", false)
```
