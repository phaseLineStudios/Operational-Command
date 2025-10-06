# TerrainData::_set_contour_interval_m Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 159–163)</br>
*Belongs to:* [TerrainData](../TerrainData.md)

**Signature**

```gdscript
func _set_contour_interval_m(v)
```

## Source

```gdscript
func _set_contour_interval_m(v):
	contour_interval_m = v
	emit_signal("changed")
```
