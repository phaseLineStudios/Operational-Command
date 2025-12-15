# TreeSpawner::_regenerate_deferred Function Reference

*Defined at:* `scripts/terrain/environments/tree_spawner.gd` (lines 155–161)</br>
*Belongs to:* [TreeSpawner](../../TreeSpawner.md)

**Signature**

```gdscript
func _regenerate_deferred() -> void
```

## Source

```gdscript
func _regenerate_deferred() -> void:
	if not is_inside_tree() or _regenerate_queued:
		return
	_regenerate_queued = true
	call_deferred("_execute_regenerate")
```
