# PathGrid::_surface_multiplier_at Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 587–602)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _surface_multiplier_at(p_m: Vector2, profile: int) -> float
```

## Source

```gdscript
func _surface_multiplier_at(p_m: Vector2, profile: int) -> float:
	var best_mult := 1.0
	var best_z := -INF
	for it in _area_features:
		var aabb: Rect2 = it.aabb
		if not aabb.has_point(p_m):
			continue
		if Geometry2D.is_point_in_polygon(p_m, it.poly):
			var brush: TerrainBrush = it.brush
			var z := brush.z_index
			if z > best_z:
				best_z = z
				best_mult = max(brush.movement_multiplier(profile), 0.0)
	return best_mult
```
