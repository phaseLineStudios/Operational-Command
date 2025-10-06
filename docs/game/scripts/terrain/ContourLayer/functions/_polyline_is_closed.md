# ContourLayer::_polyline_is_closed Function Reference

*Defined at:* `scripts/terrain/ContourLayer.gd` (lines 402–407)</br>
*Belongs to:* [ContourLayer](../ContourLayer.md)

**Signature**

```gdscript
func _polyline_is_closed(pl: PackedVector2Array, eps := 0.01) -> bool
```

## Description

Helper to check if polyline is closed

## Source

```gdscript
func _polyline_is_closed(pl: PackedVector2Array, eps := 0.01) -> bool:
	if pl.size() < 3:
		return false
	return pl[0].distance_to(pl[pl.size() - 1]) <= eps
```
