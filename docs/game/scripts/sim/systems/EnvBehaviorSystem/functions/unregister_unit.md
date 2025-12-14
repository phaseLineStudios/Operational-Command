# EnvBehaviorSystem::unregister_unit Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 48–52)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func unregister_unit(unit_id: String) -> void
```

## Description

Unregister a single unit.

## Source

```gdscript
func unregister_unit(unit_id: String) -> void:
	_nav_state_by_id.erase(unit_id)
	_speed_mult_cache.erase(unit_id)
```
