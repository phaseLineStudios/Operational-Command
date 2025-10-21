# ContourLayer::_is_thick_level_abs Function Reference

*Defined at:* `scripts/terrain/ContourLayer.gd` (lines 510–518)</br>
*Belongs to:* [ContourLayer](../../ContourLayer.md)

**Signature**

```gdscript
func _is_thick_level_abs(level: float) -> bool
```

## Description

Check if thick level is absolute elevation

## Source

```gdscript
func _is_thick_level_abs(level: float) -> bool:
	var step := float(contour_thick_every_m)
	if step <= 0.0:
		return false
	var abs_elev := level + _get_base_offset()
	var t := abs_elev / step
	return abs(t - round(t)) < 1e-4
```
