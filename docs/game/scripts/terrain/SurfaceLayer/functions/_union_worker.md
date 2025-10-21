# SurfaceLayer::_union_worker Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 358–362)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _union_worker(key: String, polys: Array, bboxes: Array, ver: int) -> void
```

## Description

Worker entry, performs AABB clustering and unions the cluster polygons

## Source

```gdscript
func _union_worker(key: String, polys: Array, bboxes: Array, ver: int) -> void:
	var merged := _union_group_aabb(polys, bboxes)
	call_deferred("_apply_union_result", key, merged, ver)
```
