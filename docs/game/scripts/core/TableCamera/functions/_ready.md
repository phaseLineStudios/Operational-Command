# TableCamera::_ready Function Reference

*Defined at:* `scripts/core/Camera.gd` (lines 24–38)</br>
*Belongs to:* [TableCamera](../TableCamera.md)

**Signature**

```gdscript
func _ready()
```

## Source

```gdscript
func _ready():
	bounds.transparency = 1

	_half_x = bounds.mesh.size.x * 0.5
	_half_z = bounds.mesh.size.y * 0.5

	camera.global_position.y = bounds.position.y
	_clamp_to_bounds()

	_target_pos = camera.global_position

	_update_target_tilt_from_z()
	camera.rotation_degrees.x = rad_to_deg(_target_tilt_rad)
```
