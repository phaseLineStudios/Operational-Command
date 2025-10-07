# TerrainData::_set_grid_x Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 139–143)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func _set_grid_x(_v: int) -> void
```

## Source

```gdscript
func _set_grid_x(_v: int) -> void:
	grid_start_x = _v
	emit_signal("changed")
```
