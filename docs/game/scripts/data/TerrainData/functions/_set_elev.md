# TerrainData::_set_elev Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 149–158)</br>
*Belongs to:* [TerrainData](../TerrainData.md)

**Signature**

```gdscript
func _set_elev(img: Image) -> void
```

## Source

```gdscript
func _set_elev(img: Image) -> void:
	if img.is_empty():
		elevation = Image.create(64, 64, false, Image.FORMAT_RF)
	else:
		elevation = img
	_resample_or_resize()
	_update_scale()
	emit_signal("changed")
```
