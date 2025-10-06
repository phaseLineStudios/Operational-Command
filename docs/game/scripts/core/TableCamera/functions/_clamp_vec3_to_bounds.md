# TableCamera::_clamp_vec3_to_bounds Function Reference

*Defined at:* `scripts/core/Camera.gd` (lines 74–81)</br>
*Belongs to:* [TableCamera](../TableCamera.md)

**Signature**

```gdscript
func _clamp_vec3_to_bounds(p: Vector3) -> Vector3
```

## Description

Clamp an arbitrary position to bounds

## Source

```gdscript
func _clamp_vec3_to_bounds(p: Vector3) -> Vector3:
	var cx := bounds.position.x
	var cz := bounds.position.z
	p.x = clamp(p.x, cx - _half_x, cx + _half_x)
	p.z = clamp(p.z, cz - _half_z, cz + _half_z)
	return p
```
