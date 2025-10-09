# SimWorld::get_unit_snapshot Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 257–261)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func get_unit_snapshot(unit_id: String) -> Dictionary
```

## Description

Shallow snapshot of a unit for UI.
[param unit_id] ScenarioUnit id.
[return] Snapshot dictionary.

## Source

```gdscript
func get_unit_snapshot(unit_id: String) -> Dictionary:
	var su: ScenarioUnit = _units_by_id.get(unit_id)
	return _snapshot_unit(su)
```
