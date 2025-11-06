# UnitCounterController::_terrain_to_world Function Reference

*Defined at:* `scripts/sim/UnitCounterController.gd` (lines 144–189)</br>
*Belongs to:* [UnitCounterController](../../UnitCounterController.md)

**Signature**

```gdscript
func _terrain_to_world(pos_m: Vector2) -> Variant
```

- **pos_m**: Terrain position in meters.
- **Return Value**: World position as Vector3, or null if conversion fails.

## Description

Convert terrain 2D position to 3D world position on the map.

## Source

```gdscript
func _terrain_to_world(pos_m: Vector2) -> Variant:
	if _terrain_render == null:
		LogService.warning("_terrain_to_world: _terrain_render is null", "UnitCounterController.gd")
		return null

	if _map_mesh == null or _map_mesh.mesh == null:
		LogService.warning(
			"_terrain_to_world: map_mesh or mesh is null", "UnitCounterController.gd"
		)
		return null

	var mesh_size := Vector2.ZERO
	if _map_mesh.mesh is PlaneMesh:
		mesh_size = _map_mesh.mesh.size
	else:
		LogService.warning(
			"_terrain_to_world: map_mesh.mesh is not PlaneMesh", "UnitCounterController.gd"
		)
		return null

	if _terrain_render.data == null:
		LogService.warning(
			"_terrain_to_world: terrain_render.data is null", "UnitCounterController.gd"
		)
		return null

	var terrain_width_m := float(_terrain_render.data.width_m)
	var terrain_height_m := float(_terrain_render.data.height_m)

	if terrain_width_m == 0 or terrain_height_m == 0:
		LogService.warning(
			"_terrain_to_world: terrain dimensions are zero", "UnitCounterController.gd"
		)
		return null

	# Normalize terrain position to -0.5..0.5 range (mesh local space)
	var normalized_x := (pos_m.x / terrain_width_m) - 0.5
	var normalized_z := (pos_m.y / terrain_height_m) - 0.5

	# Scale to mesh size
	var local_pos := Vector3(normalized_x * mesh_size.x, 0, normalized_z * mesh_size.y)

	# Convert to world space
	var world_pos := _map_mesh.to_global(local_pos)

	return world_pos
```
