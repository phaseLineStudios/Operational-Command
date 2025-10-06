# PathGrid::_road_bias_at Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 623–634)</br>
*Belongs to:* [PathGrid](../PathGrid.md)

**Signature**

```gdscript
func _road_bias_at(p_m: Vector2) -> float
```

## Source

```gdscript
func _road_bias_at(p_m: Vector2) -> float:
	var pref := 1.0
	for it in _line_features:
		if it.brush.road_bias < 1.0:
			var aabb: Rect2 = it.aabb
			if aabb.has_point(p_m):
				var d := _dist_point_polyline(p_m, it.pts)
				if d <= line_influence_radius_m:
					pref = min(pref, max(0.05, it.brush.road_bias))
	return pref
```
