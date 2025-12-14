# EnvBehaviorSystem::_find_unit_by_id Function Reference

*Defined at:* `scripts/sim/systems/EnvBehaviorSystem.gd` (lines 225–236)</br>
*Belongs to:* [EnvBehaviorSystem](../../EnvBehaviorSystem.md)

**Signature**

```gdscript
func _find_unit_by_id(unit_id: String) -> ScenarioUnit
```

## Description

Find a ScenarioUnit by id in the current scenario.

## Source

```gdscript
func _find_unit_by_id(unit_id: String) -> ScenarioUnit:
	if Game.current_scenario == null:
		return null
	for su in Game.current_scenario.units:
		if su != null and String(su.id) == unit_id:
			return su
	for su2 in Game.current_scenario.playable_units:
		if su2 != null and String(su2.id) == unit_id:
			return su2
	return null
```
