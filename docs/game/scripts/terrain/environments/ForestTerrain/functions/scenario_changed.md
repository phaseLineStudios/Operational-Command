# ForestTerrain::scenario_changed Function Reference

*Defined at:* `scripts/terrain/environments/ForestTerrain.gd` (lines 22–29)</br>
*Belongs to:* [ForestTerrain](../../ForestTerrain.md)

**Signature**

```gdscript
func scenario_changed(new_scenario: ScenarioData) -> void
```

## Source

```gdscript
func scenario_changed(new_scenario: ScenarioData) -> void:
	if not new_scenario:
		return
	print(new_scenario)
	_scenario = new_scenario
	check_rain()
```
