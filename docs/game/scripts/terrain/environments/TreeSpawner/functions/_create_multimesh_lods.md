# TreeSpawner::_create_multimesh_lods Function Reference

*Defined at:* `scripts/terrain/environments/tree_spawner.gd` (lines 323–340)</br>
*Belongs to:* [TreeSpawner](../../TreeSpawner.md)

**Signature**

```gdscript
func _create_multimesh_lods() -> void
```

## Description

Create MultiMeshInstance for each LOD level

## Source

```gdscript
func _create_multimesh_lods() -> void:
	if _tree_transforms.is_empty():
		push_warning("[TreeSpawner] No tree transforms generated")
		return

	# LOD0 - High detail
	if not tree_meshes_lod0.is_empty():
		_create_lod_level(tree_meshes_lod0, 0, lod0_distance, "LOD0")

	# LOD1 - Medium detail
	if not tree_meshes_lod1.is_empty():
		_create_lod_level(tree_meshes_lod1, lod0_distance, lod1_distance, "LOD1")

	# LOD2 - Low detail
	if not tree_meshes_lod2.is_empty():
		_create_lod_level(tree_meshes_lod2, lod1_distance, lod2_distance, "LOD2")
```
