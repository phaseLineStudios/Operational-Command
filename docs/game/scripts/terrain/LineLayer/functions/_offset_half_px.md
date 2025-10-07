# LineLayer::_offset_half_px Function Reference

*Defined at:* `scripts/terrain/LineLayer.gd` (lines 259–265)</br>
*Belongs to:* [LineLayer](../../LineLayer.md)

**Signature**

```gdscript
func _offset_half_px(pts: PackedVector2Array) -> PackedVector2Array
```

## Description

Offset all points by half a pixel to align odd widths to pixel centers

## Source

```gdscript
func _offset_half_px(pts: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in pts:
		out.append(p + Vector2(0.5, 0.5))
	return out
```
