# TriggerEngine::get_unit_snapshot Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 256–262)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func get_unit_snapshot(id_or_callsign: String) -> Dictionary
```

- **id_or_callsign**: ID or Callsign of unit.
- **Return Value**: {id, callsign, pos_m: Vector2, aff: int} or {}.

## Description

Get a unit snapshot.

## Source

```gdscript
func get_unit_snapshot(id_or_callsign: String) -> Dictionary:
	var id := id_or_callsign
	if not _snap_by_id.has(id):
		id = _id_by_callsign.get(id_or_callsign, "")
	return _snap_by_id.get(id, {})
```
