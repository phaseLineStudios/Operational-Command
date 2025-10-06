# TerrainData::_set_grid_y Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 144–148)</br>
*Belongs to:* [TerrainData](../TerrainData.md)

**Signature**

```gdscript
func _set_grid_y(_v: int) -> void
```

## Source

```gdscript
func _set_grid_y(_v: int) -> void:
	grid_start_y = _v
	emit_signal("changed")
```
