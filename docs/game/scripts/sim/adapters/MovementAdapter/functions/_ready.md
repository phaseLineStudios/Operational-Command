# MovementAdapter::_ready Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 76–88)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Initialize grid hooks and build the label index.

## Source

```gdscript
func _ready() -> void:
	_grid = renderer.path_grid
	_refresh_label_index()

	if _grid and not _grid.is_connected("build_ready", Callable(self, "_on_grid_ready")):
		_grid.build_ready.connect(_on_grid_ready)

	if actor_path.is_empty():
		_actor = get_parent() as Node3D
	else:
		_actor = get_node_or_null(actor_path) as Node3D
```
