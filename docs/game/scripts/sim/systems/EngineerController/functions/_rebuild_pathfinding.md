# EngineerController::_rebuild_pathfinding Function Reference

*Defined at:* `scripts/sim/systems/EngineerController.gd` (lines 398–427)</br>
*Belongs to:* [EngineerController](../../EngineerController.md)

**Signature**

```gdscript
func _rebuild_pathfinding() -> void
```

## Description

Rebuild pathfinding grid after terrain modification

## Source

```gdscript
func _rebuild_pathfinding() -> void:
	if not terrain_renderer or not terrain_renderer.path_grid:
		LogService.warning(
			"Cannot rebuild pathfinding: no path_grid available", "EngineerController"
		)
		return

	var path_grid: PathGrid = terrain_renderer.path_grid

	path_grid._astar_cache.clear()
	path_grid._slope_cache.clear()
	path_grid._line_dist_cache.clear()

	path_grid._lines_epoch += 1

	var profiles := [
		TerrainBrush.MoveProfile.TRACKED,
		TerrainBrush.MoveProfile.WHEELED,
		TerrainBrush.MoveProfile.FOOT,
		TerrainBrush.MoveProfile.RIVERINE
	]

	for profile in profiles:
		if path_grid.has_profile(profile):
			pass
		path_grid.rebuild(profile)

	LogService.info("Pathfinding grid rebuilt after bridge placement", "EngineerController")
```
