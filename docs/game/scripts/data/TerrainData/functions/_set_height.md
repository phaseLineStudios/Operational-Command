# TerrainData::_set_height Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 132–138)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func _set_height(v: int) -> void
```

## Source

```gdscript
func _set_height(v: int) -> void:
	height_m = max(100, v)
	_resample_or_resize()
	_update_scale()
	emit_signal("changed")
```
