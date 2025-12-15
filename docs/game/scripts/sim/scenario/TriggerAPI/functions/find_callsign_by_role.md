# TriggerAPI::find_callsign_by_role Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 123–136)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func find_callsign_by_role(role: String) -> String
```

- **role**: Role string to search for (e.g., "RECON", "ARMOR", "AT", "ENG").
- **Return Value**: Callsign string of first matching unit, or empty string if not found.

## Description

Find callsign of first playable unit with the specified role.
Searches through playable units and returns the callsign of the first unit
whose UnitData.role matches the specified role string.

## Source

```gdscript
func find_callsign_by_role(role: String) -> String:
	if not engine or not engine._scenario:
		return ""

	var playable_units: Array = engine._scenario.playable_units
	for su in playable_units:
		if su == null or su.unit == null:
			continue
		if su.unit.role == role and not su.callsign.is_empty():
			return su.callsign

	return ""
```
