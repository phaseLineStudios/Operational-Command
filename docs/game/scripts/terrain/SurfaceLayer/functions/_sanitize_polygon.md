# SurfaceLayer::_sanitize_polygon Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 525–544)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _sanitize_polygon(pts_in: PackedVector2Array) -> PackedVector2Array
```

## Description

Removes duplicate/adjacent points and optional duplicated closing vertex

## Source

```gdscript
func _sanitize_polygon(pts_in: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	if pts_in.size() < 3:
		return out
	var n := pts_in.size()
	var first := pts_in[0]
	var last := pts_in[n - 1]
	var end_n := n - 1 if first.distance_squared_to(last) < 1e-12 else n
	var eps2 := 1e-10
	var prev := Vector2.INF
	for i in range(end_n):
		var p := pts_in[i]
		if not prev.is_finite() or prev.distance_squared_to(p) > eps2:
			out.append(p)
		prev = p
	if out.size() < 3:
		return PackedVector2Array()
	return out
```
