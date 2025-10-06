# PathGrid::_prepare_slope_cache Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 552–563)</br>
*Belongs to:* [PathGrid](../PathGrid.md)

**Signature**

```gdscript
func _prepare_slope_cache() -> void
```

## Description

Build or reuse the slope “multiplier” raster (profile-agnostic)

## Source

```gdscript
func _prepare_slope_cache() -> void:
	var key := _raster_key("slope")
	if _slope_cache.has(key):
		return
	var arr := PackedFloat32Array()
	arr.resize(_cols * _rows)
	for cy in _rows:
		for cx in _cols:
			arr[cy * _cols + cx] = _slope_multiplier_at_cell(cx, cy)
	_slope_cache[key] = arr
```
