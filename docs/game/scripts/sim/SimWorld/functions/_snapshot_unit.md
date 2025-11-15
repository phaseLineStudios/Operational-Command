# SimWorld::_snapshot_unit Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 580–596)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _snapshot_unit(su: ScenarioUnit) -> Dictionary
```

- **su**: ScenarioUnit instance (nullable).
- **Return Value**: Snapshot dictionary or empty if null.

## Description

Build a compact unit snapshot.

## Source

```gdscript
func _snapshot_unit(su: ScenarioUnit) -> Dictionary:
	if su == null:
		return {}
	var strength := su.unit.strength * su.unit.state_strength
	var destroyed := su.is_dead()

	return {
		"id": su.id,
		"callsign": su.callsign,
		"pos_m": su.position_m,
		"aff": int(su.affiliation),
		"state": int(su.move_state()),
		"strength": strength,
		"dead": destroyed or strength <= 0.0
	}
```
