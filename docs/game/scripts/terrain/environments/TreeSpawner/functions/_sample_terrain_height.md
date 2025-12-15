# TreeSpawner::_sample_terrain_height Function Reference

*Defined at:* `scripts/terrain/environments/tree_spawner.gd` (lines 274–292)</br>
*Belongs to:* [TreeSpawner](../../TreeSpawner.md)

**Signature**

```gdscript
func _sample_terrain_height(pos_2d: Vector2) -> float
```

## Source

```gdscript
func _sample_terrain_height(pos_2d: Vector2) -> float:
	if terrain == null:
		return 0.0

	# Simple raycast down from above
	var space_state := get_world_3d().direct_space_state
	if space_state == null:
		return 0.0

	var query := PhysicsRayQueryParameters3D.create(
		global_position + Vector3(pos_2d.x, 100, pos_2d.y),
		global_position + Vector3(pos_2d.x, -100, pos_2d.y)
	)
	var result := space_state.intersect_ray(query)
	if result:
		return result.position.y
	return 0.0
```
