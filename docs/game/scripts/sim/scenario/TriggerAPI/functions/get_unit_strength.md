# TriggerAPI::get_unit_strength Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 428–434)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func get_unit_strength(id_or_callsign: String) -> float
```

- **id_or_callsign**: Unit ID or callsign.
- **Return Value**: Current strength value (0.0 if destroyed/not found).

## Description

Get the current strength of a unit.
Strength is calculated as base strength × state_strength.

## Source

```gdscript
func get_unit_strength(id_or_callsign: String) -> float:
	var unit_data := unit(id_or_callsign)
	if unit_data.is_empty():
		return 0.0
	return unit_data.get("strength", 0.0)
```
