# SurfaceLayer::_union_group Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 443–446)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _union_group(polys: Array) -> Array
```

## Description

Convenience passthrough to the non-AABB union implementation

## Source

```gdscript
func _union_group(polys: Array) -> Array:
	return _union_polys(polys)
```
