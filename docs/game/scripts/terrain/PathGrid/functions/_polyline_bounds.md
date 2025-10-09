# PathGrid::_polyline_bounds Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 902–908)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func _polyline_bounds(pts: PackedVector2Array) -> Rect2
```

## Source

```gdscript
static func _polyline_bounds(pts: PackedVector2Array) -> Rect2:
	var r := Rect2(pts[0], Vector2.ZERO)
	for i in range(1, pts.size()):
		r = r.expand(pts[i])
	return r
```
