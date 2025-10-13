# SurfaceLayer::_union_polys Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 495–523)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _union_polys(polys: Array) -> Array
```

## Description

Unions an array of polygons pairwise (fallback/slow path)

## Source

```gdscript
func _union_polys(polys: Array) -> Array:
	if polys.is_empty():
		return []
	var clean: Array = []
	for p in polys:
		var s := _sanitize_polygon(p)
		if s.size() >= 3 and abs(_polygon_area(s)) > 1e-6:
			clean.append(s)
	if clean.is_empty():
		return []
	var acc: Array = [clean[0]]
	for i in range(1, clean.size()):
		var b: PackedVector2Array = clean[i]
		var new_acc: Array = []
		var merged_any := false
		for a in acc:
			var res: Array = Geometry2D.merge_polygons(a, b)
			if res.is_empty():
				new_acc.append(a)
			else:
				for r in res:
					new_acc.append(r)
				merged_any = true
		if not merged_any:
			new_acc.append(b)
		acc = new_acc
	return acc
```
