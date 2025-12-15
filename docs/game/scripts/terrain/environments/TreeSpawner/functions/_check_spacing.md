# TreeSpawner::_check_spacing Function Reference

*Defined at:* `scripts/terrain/environments/tree_spawner.gd` (lines 266–273)</br>
*Belongs to:* [TreeSpawner](../../TreeSpawner.md)

**Signature**

```gdscript
func _check_spacing(pos: Vector2) -> bool
```

## Source

```gdscript
func _check_spacing(pos: Vector2) -> bool:
	for t in _tree_transforms:
		var existing_pos := Vector2(t.origin.x, t.origin.z)
		if pos.distance_to(existing_pos) < min_tree_spacing:
			return false
	return true
```
