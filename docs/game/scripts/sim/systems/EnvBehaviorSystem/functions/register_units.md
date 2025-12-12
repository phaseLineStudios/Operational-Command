# EnvBehaviorSystem::register_units Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 36–49)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func register_units(units: Array) -> void
```

## Description

Register units and attach navigation state.

## Source

```gdscript
func register_units(units: Array) -> void:
	for su in units:
		if su == null:
			continue
		var uid := String(su.id)
		if uid == "":
			continue
		# Force ALPHA to start in CARELESS for testing.
		if su.callsign.to_upper() == "ALPHA":
			su.behaviour = ScenarioUnit.Behaviour.CARELESS
		if not _nav_state_by_id.has(uid):
			_nav_state_by_id[uid] = UnitNavigationState.new()
```
