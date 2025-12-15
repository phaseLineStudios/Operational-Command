# TreeSpawner::regenerate Function Reference

*Defined at:* `scripts/terrain/environments/tree_spawner.gd` (lines 175–192)</br>
*Belongs to:* [TreeSpawner](../../TreeSpawner.md)

**Signature**

```gdscript
func regenerate() -> void
```

## Description

Main regeneration function

## Source

```gdscript
func regenerate() -> void:
	print("[TreeSpawner] Regenerating forest with LODs...")
	clear_trees()

	# Generate tree transforms (shared by all LODs)
	_generate_tree_transforms()

	# Create MultiMesh for each LOD level
	_create_multimesh_lods()

	print(
		(
			"[TreeSpawner] Generated %d trees across %d LOD levels"
			% [_tree_transforms.size(), _count_lod_levels()]
		)
	)
```
