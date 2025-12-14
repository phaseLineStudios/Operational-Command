# HQTable::_terrain_pos_to_world Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 447–476)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _terrain_pos_to_world(pos_m: Vector2) -> Variant
```

- **pos_m**: Terrain position in meters (Vector2).
- **Return Value**: World position as Vector3, or null if conversion fails.

## Description

Convert terrain 2D position to 3D world position on the map.

## Source

```gdscript
func _terrain_pos_to_world(pos_m: Vector2) -> Variant:
	if map == null or map.renderer == null:
		return null

	var map_mesh: MeshInstance3D = %Map
	if map_mesh == null or map_mesh.mesh == null:
		return null

	var mesh_size := Vector2.ZERO
	if map_mesh.mesh is PlaneMesh:
		mesh_size = map_mesh.mesh.size
	else:
		return null

	var map_px := renderer.terrain_to_map(pos_m)

	var map_size := renderer.size
	if map_size.x == 0 or map_size.y == 0:
		return null

	var normalized_x := (map_px.x / map_size.x) - 0.5
	var normalized_z := (map_px.y / map_size.y) - 0.5

	var local_pos := Vector3(normalized_x * mesh_size.x, 0, normalized_z * mesh_size.y)

	var world_pos := map_mesh.to_global(local_pos)

	return world_pos
```
