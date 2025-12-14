# EnvBehaviorSystem::register_units Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 36–46)</br>
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
		if not _nav_state_by_id.has(uid):
			_nav_state_by_id[uid] = UnitNavigationState.new()
```
