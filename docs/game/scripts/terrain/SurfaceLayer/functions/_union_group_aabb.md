# SurfaceLayer::_union_group_aabb Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 397–441)</br>
*Belongs to:* [SurfaceLayer](../SurfaceLayer.md)

**Signature**

```gdscript
func _union_group_aabb(polys: Array, bboxes: Array) -> Array
```

## Description

Unions polygons using connected AABB clusters to minimize pairwise merges

## Source

```gdscript
func _union_group_aabb(polys: Array, bboxes: Array) -> Array:
	if polys.is_empty():
		return []
	var items: Array = []
	for i in polys.size():
		var s := _sanitize_polygon(polys[i])
		if s.size() >= 3 and abs(_polygon_area(s)) > 1e-6:
			var bb: Rect2 = (
				bboxes[i] if (i < bboxes.size() and bboxes[i] is Rect2) else _poly_bbox(s)
			)
			items.append({"poly": s, "bbox": bb})
	if items.is_empty():
		return []

	var n := items.size()
	var visited := PackedByteArray()
	visited.resize(n)
	var clusters: Array = []
	for i in n:
		if visited[i] != 0:
			continue
		var stack := [i]
		visited[i] = 1
		var cluster_idx := []
		while not stack.is_empty():
			var a := int(stack.pop_back())
			cluster_idx.append(a)
			var bb_a: Rect2 = items[a].bbox
			for j in n:
				if visited[j] != 0:
					continue
				var bb_b: Rect2 = items[j].bbox
				if bb_a.intersects(bb_b, true):
					visited[j] = 1
					stack.append(j)
		var cluster_polys: Array = []
		for k in cluster_idx:
			cluster_polys.append(items[k].poly)
		var merged_cluster := _union_polys(cluster_polys)
		for m in merged_cluster:
			clusters.append(m)

	return clusters
```
