# PathGrid::_ready Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 77–81)</br>
*Belongs to:* [PathGrid](../PathGrid.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	astar_setup_defaults()
	_bind_terrain_signals()
```
