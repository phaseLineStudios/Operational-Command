# TriggerAPI::get_unit_position Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 391–397)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func get_unit_position(id_or_callsign: String) -> Variant
```

- **id_or_callsign**: Unit ID or callsign.
- **Return Value**: Vector2 position in terrain meters, or null if unit not found.

## Description

Get the current position of a unit in terrain meters (Vector2).

## Source

```gdscript
func get_unit_position(id_or_callsign: String) -> Variant:
	var unit_data := unit(id_or_callsign)
	if unit_data.is_empty():
		return null
	return unit_data.get("position_m", null)
```
