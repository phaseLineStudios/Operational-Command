# SurfaceLayer::_closed_copy Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 448–456)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _closed_copy(pts: PackedVector2Array, closed: bool) -> PackedVector2Array
```

## Description

Returns a closed copy of a polyline (appends first point if needed)

## Source

```gdscript
func _closed_copy(pts: PackedVector2Array, closed: bool) -> PackedVector2Array:
	if closed:
		if pts[0].distance_to(pts[pts.size() - 1]) > 1e-5:
			var c := pts.duplicate()
			c.append(pts[0])
			return c
	return pts.duplicate()
```
