# TerrainData::_set_width Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 119–125)</br>
*Belongs to:* [TerrainData](../TerrainData.md)

**Signature**

```gdscript
func _set_width(v: int) -> void
```

## Source

```gdscript
func _set_width(v: int) -> void:
	width_m = max(100, v)
	_resample_or_resize()
	_update_scale()
	emit_signal("changed")
```
