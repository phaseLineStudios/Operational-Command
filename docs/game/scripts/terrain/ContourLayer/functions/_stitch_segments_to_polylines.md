# ContourLayer::_stitch_segments_to_polylines Function Reference

*Defined at:* `scripts/terrain/ContourLayer.gd` (lines 334–392)</br>
*Belongs to:* [ContourLayer](../ContourLayer.md)

**Signature**

```gdscript
func _stitch_segments_to_polylines(segments: Array) -> Array
```

## Description

Stitch segments into polylines

## Source

```gdscript
func _stitch_segments_to_polylines(segments: Array) -> Array:
	var polylines: Array = []
	if segments.is_empty():
		return polylines

	var eps := 0.001
	var key = func(p: Vector2) -> Vector2:
		return Vector2(round(p.x / eps) * eps, round(p.y / eps) * eps)

	var start_map: Dictionary = {}
	var end_map: Dictionary = {}

	for seg: PackedVector2Array in segments:
		var a := seg[0]
		var b := seg[1]
		var ka: Vector2 = key.call(a)
		var kb: Vector2 = key.call(b)

		var attached := false

		if end_map.has(ka):
			var idx: int = end_map[ka][0]
			var poly: PackedVector2Array = polylines[idx]
			poly.append(b)
			end_map.erase(ka)
			end_map[key.call(b)] = [idx, true]
			attached = true
		elif start_map.has(kb):
			var idx2: int = start_map[kb][0]
			var poly2: PackedVector2Array = polylines[idx2]
			poly2.insert(0, a)
			start_map.erase(kb)
			start_map[key.call(a)] = [idx2, true]
			attached = true
		elif start_map.has(ka):
			var idx3: int = start_map[ka][0]
			var poly3: PackedVector2Array = polylines[idx3]
			poly3.insert(0, b)
			start_map.erase(ka)
			start_map[key.call(b)] = [idx3, true]
			attached = true
		elif end_map.has(kb):
			var idx4: int = end_map[kb][0]
			var poly4: PackedVector2Array = polylines[idx4]
			poly4.append(a)
			end_map.erase(kb)
			end_map[key.call(a)] = [idx4, true]
			attached = true

		if not attached:
			var pl := PackedVector2Array([a, b])
			var id := polylines.size()
			polylines.append(pl)
			start_map[key.call(a)] = [id, true]
			end_map[key.call(b)] = [id, true]

	return polylines
```
