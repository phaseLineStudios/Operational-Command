# MapController::init_terrain Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 110–119)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func init_terrain(scenario: ScenarioData) -> void
```

## Description

Initilizes terrain for scenario

## Source

```gdscript
func init_terrain(scenario: ScenarioData) -> void:
	_scenario = scenario
	if _scenario.terrain != null:
		renderer.data = _scenario.terrain
	_bind_terrain_signals(renderer.data)
	_request_map_refresh(true)

	prebuild_force_profiles()
```
