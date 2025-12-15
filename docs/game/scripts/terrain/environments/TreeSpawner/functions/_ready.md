# TreeSpawner::_ready Function Reference

*Defined at:* `scripts/terrain/environments/tree_spawner.gd` (lines 147–154)</br>
*Belongs to:* [TreeSpawner](../../TreeSpawner.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_setup_noise()
	if not Engine.is_editor_hint():
		# At runtime, check if we have baked children
		if get_child_count() == 0:
			_generate_forest_all_lods()
```
