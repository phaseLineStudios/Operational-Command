# PathGrid::_prepare_line_dist_cache Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 565–586)</br>
*Belongs to:* [PathGrid](../PathGrid.md)

**Signature**

```gdscript
func _prepare_line_dist_cache() -> void
```

## Description

distance-to-nearest-line cache (profile-agnostic)

## Source

```gdscript
func _prepare_line_dist_cache() -> void:
	var key := _raster_key("line")
	if _line_dist_cache.has(key):
		return
	if _line_features.is_empty():
		_line_dist_cache.erase(key)
		return

	var arr := PackedFloat32Array()
	arr.resize(_cols * _rows)
	for cy in _rows:
		for cx in _cols:
			var p := _cell_center_m(Vector2i(cx, cy))
			var best := INF
			for it in _line_features:
				if not it.aabb.has_point(p):
					continue
				best = min(best, _dist_point_polyline(p, it.pts))
			arr[cy * _cols + cx] = best
	_line_dist_cache[key] = arr
```
