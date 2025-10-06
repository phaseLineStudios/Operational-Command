# TableCamera::_clamp_to_bounds Function Reference

*Defined at:* `scripts/core/Camera.gd` (lines 66–72)</br>
*Belongs to:* [TableCamera](../TableCamera.md)

**Signature**

```gdscript
func _clamp_to_bounds() -> void
```

## Description

Clamp Camera position to bounds

## Source

```gdscript
func _clamp_to_bounds() -> void:
	var cx := bounds.position.x
	var cz := bounds.position.z
	camera.global_position.x = clamp(camera.global_position.x, cx - _half_x, cx + _half_x)
	camera.global_position.z = clamp(camera.global_position.z, cz - _half_z, cz + _half_z)
```
