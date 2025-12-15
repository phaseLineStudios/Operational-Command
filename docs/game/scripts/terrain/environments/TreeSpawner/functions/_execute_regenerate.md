# TreeSpawner::_execute_regenerate Function Reference

*Defined at:* `scripts/terrain/environments/tree_spawner.gd` (lines 162–166)</br>
*Belongs to:* [TreeSpawner](../../TreeSpawner.md)

**Signature**

```gdscript
func _execute_regenerate() -> void
```

## Source

```gdscript
func _execute_regenerate() -> void:
	_regenerate_queued = false
	regenerate()
```
