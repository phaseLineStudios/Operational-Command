# ForestTerrain::_ready Function Reference

*Defined at:* `scripts/terrain/environments/ForestTerrain.gd` (lines 11–21)</br>
*Belongs to:* [ForestTerrain](../../ForestTerrain.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	terrain_mesh = terrain.get_node_or_null("Terrain")
	if not terrain_mesh:
		LogService.warning("Didn't find Terrain Mesh.", "forest_terrain.gd:14")
		return
	scene_env.scenario_changed.connect(scenario_changed)
	scenario_changed(
		scene_env.get_scenario() if scene_env.get_scenario() else Game.current_scenario
	)
```
