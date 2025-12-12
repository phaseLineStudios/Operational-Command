# EnvBehaviorSystem::_set_stuck_soft Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 362–370)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func _set_stuck_soft(unit_id: String, nav: UnitNavigationState) -> void
```

## Description

Mark a unit as stuck and halt movement until engineers assist.

## Source

```gdscript
func _set_stuck_soft(unit_id: String, nav: UnitNavigationState) -> void:
	nav.set_nav_state(UnitNavigationState.NavState.STUCK_SOFT)
	_emit_speed_change(unit_id, 0.0)
	LogService.warning(
		"Unit %s stuck in soft ground; engineer required" % unit_id, "EnvBehaviorSystem.gd"
	)
	emit_signal("unit_bogged", unit_id)
```
