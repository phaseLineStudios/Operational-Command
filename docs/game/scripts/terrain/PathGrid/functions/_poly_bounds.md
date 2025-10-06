# PathGrid::_poly_bounds Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 877–883)</br>
*Belongs to:* [PathGrid](../PathGrid.md)

**Signature**

```gdscript
func _poly_bounds(poly: PackedVector2Array) -> Rect2
```

## Source

```gdscript
static func _poly_bounds(poly: PackedVector2Array) -> Rect2:
	var r := Rect2(poly[0], Vector2.ZERO)
	for i in range(1, poly.size()):
		r = r.expand(poly[i])
	return r
```
