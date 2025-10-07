# PathGrid::_line_multiplier_at Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 607–622)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _line_multiplier_at(p_m: Vector2, profile: int) -> float
```

## Source

```gdscript
func _line_multiplier_at(p_m: Vector2, profile: int) -> float:
	var out := 1.0
	for it in _line_features:
		var aabb: Rect2 = it.aabb
		if not aabb.has_point(p_m):
			continue
		var eff_r_m := line_influence_radius_m
		if eff_r_m <= 0.0:
			eff_r_m = _line_px_to_meters(float(it.width_px)) * 0.5
		var d := _dist_point_polyline(p_m, it.pts)
		if d <= eff_r_m:
			var m: float = max(it.brush.movement_multiplier(profile), 0.0)
			out = min(out, m)
	return out
```
