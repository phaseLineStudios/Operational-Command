# PathGrid::_dist_point_polyline Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 891–899)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _dist_point_polyline(p: Vector2, pts: PackedVector2Array) -> float
```

## Source

```gdscript
static func _dist_point_polyline(p: Vector2, pts: PackedVector2Array) -> float:
	var best := INF
	for i in range(1, pts.size()):
		best = min(
			best, Geometry2D.get_closest_point_to_segment(p, pts[i - 1], pts[i]).distance_to(p)
		)
	return best
```
