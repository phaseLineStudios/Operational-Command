# SimWorld::init_resolution Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 156–166)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func init_resolution(objs: Array[ScenarioObjectiveData]) -> void
```

- **primary_ids**: Objective IDs.
- **scenario**: Scenario to initialize.

## Description

Initialize mission resolution and connect state changes.

## Source

```gdscript
func init_resolution(objs: Array[ScenarioObjectiveData]) -> void:
	var primary_ids: Array[String] = []
	for obj in objs:
		primary_ids.append(obj.id)
	Game.start_scenario(primary_ids)
	if not mission_state_changed.is_connected(_on_state_change_for_resolution):
		mission_state_changed.connect(_on_state_change_for_resolution)
	if Game.resolution.objective_updated.is_connected(_on_objective_updated):
		Game.resolution.objective_updated.connect(_on_objective_updated)
```
