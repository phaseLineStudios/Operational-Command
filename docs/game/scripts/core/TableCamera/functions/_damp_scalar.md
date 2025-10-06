# TableCamera::_damp_scalar Function Reference

*Defined at:* `scripts/core/Camera.gd` (lines 104–108)</br>
*Belongs to:* [TableCamera](../TableCamera.md)

**Signature**

```gdscript
func _damp_scalar(a: float, b: float, k: float, dt: float) -> float
```

## Description

Exponential damping for scalars

## Source

```gdscript
static func _damp_scalar(a: float, b: float, k: float, dt: float) -> float:
	if k <= 0.0 or dt <= 0.0:
		return b
	var t := 1.0 - exp(-k * dt)
	return lerp(a, b, clamp(t, 0.0, 1.0))
```
