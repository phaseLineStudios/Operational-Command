# PathGrid::debug_line_dist_cell Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 761–773)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func debug_line_dist_cell(c: Vector2i) -> float
```

## Description

Distance to nearest line at cell (uses cache if present; INF if none).

## Source

```gdscript
func debug_line_dist_cell(c: Vector2i) -> float:
	var key := _raster_key("line")
	if _line_dist_cache.has(key) and _line_dist_cache[key].size() > 0:
		return _line_dist_cache[key][c.y * _cols + c.x]
	var p := _cell_center_m(c)
	var best := INF
	for it in _line_features:
		if not it.aabb.has_point(p):
			continue
		best = min(best, _dist_point_polyline(p, it.pts))
	return best
```
