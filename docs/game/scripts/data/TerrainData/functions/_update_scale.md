# TerrainData::_update_scale Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 437–442)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func _update_scale() -> void
```

## Description

Update heightmap scale

## Source

```gdscript
func _update_scale() -> void:
	if elevation.is_empty():
		return
	_px_per_m = float(elevation.get_width()) / float(max(width_m, 1))
```
