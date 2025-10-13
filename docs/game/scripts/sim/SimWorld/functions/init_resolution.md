# SimWorld::init_resolution Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 100–105)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func init_resolution(primary_ids: Array[StringName], scenario: ScenarioData) -> void
```

- **primary_ids**: Objective IDs.
- **scenario**: Scenario to initialize.

## Description

Initialize mission resolution and connect state changes.

## Source

```gdscript
func init_resolution(primary_ids: Array[StringName], scenario: ScenarioData) -> void:
	Game.resolution.start(primary_ids, scenario.id)
	if not mission_state_changed.is_connected(_on_state_change_for_resolution):
		mission_state_changed.connect(_on_state_change_for_resolution)
```
