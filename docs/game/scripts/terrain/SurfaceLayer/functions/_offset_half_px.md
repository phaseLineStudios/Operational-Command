# SurfaceLayer::_offset_half_px Function Reference

*Defined at:* `scripts/terrain/SurfaceLayer.gd` (lines 458–464)</br>
*Belongs to:* [SurfaceLayer](../../SurfaceLayer.md)

**Signature**

```gdscript
func _offset_half_px(pts: PackedVector2Array) -> PackedVector2Array
```

## Description

Offsets all points by (0.5, 0.5) to align odd-width strokes to pixel centers

## Source

```gdscript
func _offset_half_px(pts: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in pts:
		out.append(p + Vector2(0.5, 0.5))
	return out
```
