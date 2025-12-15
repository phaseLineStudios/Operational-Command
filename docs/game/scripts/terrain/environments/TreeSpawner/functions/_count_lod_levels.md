# TreeSpawner::_count_lod_levels Function Reference

*Defined at:* `scripts/terrain/environments/tree_spawner.gd` (lines 311–321)</br>
*Belongs to:* [TreeSpawner](../../TreeSpawner.md)

**Signature**

```gdscript
func _count_lod_levels() -> int
```

## Source

```gdscript
func _count_lod_levels() -> int:
	var count := 0
	if not tree_meshes_lod0.is_empty():
		count += 1
	if not tree_meshes_lod1.is_empty():
		count += 1
	if not tree_meshes_lod2.is_empty():
		count += 1
	return count
```
