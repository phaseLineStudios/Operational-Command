# SimWorld::_snapshot_unit Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 293–304)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _snapshot_unit(su: ScenarioUnit) -> Dictionary
```

## Description

Build a compact unit snapshot.
[param su] ScenarioUnit instance (nullable).
[return] Snapshot dictionary or empty if null.

## Source

```gdscript
func _snapshot_unit(su: ScenarioUnit) -> Dictionary:
	if su == null:
		return {}
	return {
		"id": su.id,
		"callsign": su.callsign,
		"pos_m": su.position_m,
		"aff": int(su.affiliation),
		"state": int(su.move_state())
	}
```
