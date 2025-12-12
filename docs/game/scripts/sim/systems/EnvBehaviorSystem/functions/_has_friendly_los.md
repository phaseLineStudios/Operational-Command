# EnvBehaviorSystem::_has_friendly_los Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 333–348)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func _has_friendly_los(unit: ScenarioUnit) -> bool
```

## Description

True if any friendly has LOS to this unit.

## Source

```gdscript
func _has_friendly_los(unit: ScenarioUnit) -> bool:
	if los_adapter == null or Game.current_scenario == null or unit == null:
		return false
	var all_units: Array = []
	all_units.append_array(Game.current_scenario.units)
	all_units.append_array(Game.current_scenario.playable_units)
	for other in all_units:
		if other == null or other == unit or other.is_dead():
			continue
		if other.affiliation != unit.affiliation:
			continue
		if los_adapter.has_los(other, unit) or los_adapter.has_los(unit, other):
			return true
	return false
```
