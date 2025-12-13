# UnitCounterController::_terrain_to_world Function Reference

*Defined at:* `scripts/sim/UnitCounterController.gd` (lines 144–185)</br>
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

	# Convert terrain meters to map pixels (includes margins and borders)
	var map_px := _terrain_render.terrain_to_map(pos_m)

	# Get total map size in pixels (includes margins)
	var map_size := _terrain_render.size
	if map_size.x == 0 or map_size.y == 0:
		LogService.warning(
			"_terrain_to_world: terrain render size is zero", "UnitCounterController.gd"
		)
		return null

	# Normalize to -0.5..0.5 range (mesh local space)
	var normalized_x := (map_px.x / map_size.x) - 0.5
	var normalized_z := (map_px.y / map_size.y) - 0.5

	# Scale to mesh size
	var local_pos := Vector3(normalized_x * mesh_size.x, 0, normalized_z * mesh_size.y)

	# Convert to world space
	var world_pos := _map_mesh.to_global(local_pos)

	return world_pos
```
