# HQTable::_terrain_pos_to_world Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 359–396)</br>
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

	var terrain_data := map.renderer.data
	if terrain_data == null:
		return null

	var terrain_width_m := float(terrain_data.width_m)
	var terrain_height_m := float(terrain_data.height_m)

	if terrain_width_m == 0 or terrain_height_m == 0:
		return null

	# Normalize terrain position to -0.5..0.5 range (mesh local space)
	var t_pos_m := renderer.terrain_to_map(pos_m)
	var normalized_x := (t_pos_m.x / terrain_width_m) - 0.5
	var normalized_z := (t_pos_m.y / terrain_height_m) - 0.5

	# Scale to mesh size
	var local_pos := Vector3(normalized_x * mesh_size.x, 0, normalized_z * mesh_size.y)

	# Convert to world space
	var world_pos := map_mesh.to_global(local_pos)

	return world_pos
```
