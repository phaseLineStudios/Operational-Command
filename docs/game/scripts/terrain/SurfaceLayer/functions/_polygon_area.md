# SurfaceLayer::_polygon_area Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 546–556)</br>
*Belongs to:* [SurfaceLayer](../SurfaceLayer.md)

**Signature**

```gdscript
func _polygon_area(pts: PackedVector2Array) -> float
```

## Description

Returns polygon signed area (positive for CCW)

## Source

```gdscript
static func _polygon_area(pts: PackedVector2Array) -> float:
	var n := pts.size()
	if n < 3:
		return 0.0
	var area := 0.0
	for i in n:
		var j := (i + 1) % n
		area += pts[i].x * pts[j].y - pts[j].x * pts[i].y
	return area * 0.5
```
