# TerrainData::_resample_or_resize Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 444–458)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func _resample_or_resize() -> void
```

## Description

Resmaple or resize heightmap

## Source

```gdscript
func _resample_or_resize() -> void:
	var new_w := int(round(float(width_m) / elevation_resolution_m))
	var new_h := int(round(float(height_m) / elevation_resolution_m))
	new_w = max(new_w, 8)
	new_h = max(new_h, 8)
	if elevation.get_width() == new_w and elevation.get_height() == new_h:
		return
	var old := elevation.duplicate()
	elevation = Image.create(new_w, new_h, false, Image.FORMAT_RF)
	elevation.fill(Color(0, 0, 0))
	if not old.is_empty():
		old.resize(new_w, new_h, Image.INTERPOLATE_NEAREST)
		elevation.blit_rect(old, Rect2i(Vector2i.ZERO, old.get_size()), Vector2i.ZERO)
```
