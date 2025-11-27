# TerrainData::_set_resolution Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 139–144)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func _set_resolution(v: int) -> void
```

## Source

```gdscript
func _set_resolution(v: int) -> void:
	elevation_resolution_m = clamp(v, 2, 200)
	_resample_or_resize()
	emit_signal("changed")
```
