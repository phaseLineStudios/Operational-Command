# TableCamera::_damp_vec3 Function Reference

*Defined at:* `scripts/core/Camera.gd` (lines 96–102)</br>
*Belongs to:* [TableCamera](../../TableCamera.md)

**Signature**

```gdscript
func _damp_vec3(a: Vector3, b: Vector3, k: float, dt: float) -> Vector3
```

## Description

Exponential damping for vectors

## Source

```gdscript
static func _damp_vec3(a: Vector3, b: Vector3, k: float, dt: float) -> Vector3:
	if k <= 0.0 or dt <= 0.0:
		return b
	var t := 1.0 - exp(-k * dt)
	return a.lerp(b, clamp(t, 0.0, 1.0))
```
