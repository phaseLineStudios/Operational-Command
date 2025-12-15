# TreeSpawner::clear_trees Function Reference

*Defined at:* `scripts/terrain/environments/tree_spawner.gd` (lines 194–201)</br>
*Belongs to:* [TreeSpawner](../../TreeSpawner.md)

**Signature**

```gdscript
func clear_trees() -> void
```

## Description

Clear all tree instances

## Source

```gdscript
func clear_trees() -> void:
	for child in get_children():
		if Engine.is_editor_hint():
			child.owner = null
		child.queue_free()
	_tree_transforms.clear()
```
