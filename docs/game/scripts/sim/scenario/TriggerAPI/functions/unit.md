# TriggerAPI::unit Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 109–114)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func unit(id_or_callsign: String) -> Dictionary
```

- **id_or_callsign**: Unit ID or Unit Callsign.
- **Return Value**: {id, callsign, pos_m: Vector2, aff: int} or {}.

## Description

Minimal snapshot of a unit by id or callsign.

## Source

```gdscript
func unit(id_or_callsign: String) -> Dictionary:
	if engine:
		return engine.get_unit_snapshot(id_or_callsign)
	return {}
```
