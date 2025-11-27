# SetupController::_ready Function Reference

*Defined at:* `scripts/test/PathTest.gd` (lines 17–54)</br>
*Belongs to:* [SetupController](../../SetupController.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	if terrain_path == "":
		push_warning("Setup: Terrain path missing")
		return
	if renderer == null:
		push_warning("Setup: TerrainRender missing.")
		return

	terrain = TerrainData.deserialize(terrain_path)
	renderer.data = terrain
	if renderer.path_grid == null:
		push_warning("Setup: Assign PathGrid to TerrainRender.path_grid in the Inspector.")
		return
	if unit == null:
		push_warning("Setup: ExampleUnit (MovementAgent) missing.")
		return

	unit.grid = renderer.path_grid
	unit.renderer = renderer
	renderer.data = terrain

	renderer.path_grid.rebuild(unit.profile)

	renderer.path_grid.build_ready.connect(
		func(p):
			if p == unit.profile:
				LogService.info("PathGrid ready for profile: " + str(p), "PathTest.gd:33")
	)
	renderer.path_grid.build_failed.connect(
		func(reason): push_warning("PathGrid build failed: " + reason)
	)

	renderer.path_grid.debug_enabled = true
	renderer.path_grid.debug_layer = PathGrid.DebugLayer.WEIGHT

	input_overlay.gui_input.connect(_input)
```
