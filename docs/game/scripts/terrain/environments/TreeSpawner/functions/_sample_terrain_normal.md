# TreeSpawner::_sample_terrain_normal Function Reference

*Defined at:* `scripts/terrain/environments/tree_spawner.gd` (lines 293–310)</br>
*Belongs to:* [TreeSpawner](../../TreeSpawner.md)

**Signature**

```gdscript
func _sample_terrain_normal(pos_2d: Vector2) -> Vector3
```

## Source

```gdscript
func _sample_terrain_normal(pos_2d: Vector2) -> Vector3:
	if terrain == null:
		return Vector3.UP

	var space_state := get_world_3d().direct_space_state
	if space_state == null:
		return Vector3.UP

	var query := PhysicsRayQueryParameters3D.create(
		global_position + Vector3(pos_2d.x, 100, pos_2d.y),
		global_position + Vector3(pos_2d.x, -100, pos_2d.y)
	)
	var result := space_state.intersect_ray(query)
	if result:
		return result.normal
	return Vector3.UP
```
