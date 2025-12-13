# MapController::init_terrain Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 81–88)</br>
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

	prebuild_force_profiles()
```
