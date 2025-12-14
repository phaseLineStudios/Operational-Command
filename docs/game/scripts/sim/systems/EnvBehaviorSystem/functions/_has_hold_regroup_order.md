# EnvBehaviorSystem::_has_hold_regroup_order Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 278–281)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func _has_hold_regroup_order(unit: ScenarioUnit) -> bool
```

## Description

True when unit has an explicit hold/regroup order metadata set.

## Source

```gdscript
func _has_hold_regroup_order(unit: ScenarioUnit) -> bool:
	return unit != null and unit.has_meta("hold_regroup")
```
