# SurfaceLayer::_poly_bbox Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 466–477)</br>
*Belongs to:* [SurfaceLayer](../SurfaceLayer.md)

**Signature**

```gdscript
func _poly_bbox(pts: PackedVector2Array) -> Rect2
```

## Description

Computes axis-aligned bounding box for a polygon

## Source

```gdscript
func _poly_bbox(pts: PackedVector2Array) -> Rect2:
	var minp := pts[0]
	var maxp := pts[0]
	for i in range(1, pts.size()):
		var p := pts[i]
		minp.x = min(minp.x, p.x)
		minp.y = min(minp.y, p.y)
		maxp.x = max(maxp.x, p.x)
		maxp.y = max(maxp.y, p.y)
	return Rect2(minp, maxp - minp)
```
