# TableCamera::_update_target_tilt_from_z Function Reference

*Defined at:* `scripts/core/Camera.gd` (lines 83–94)</br>
*Belongs to:* [TableCamera](../../TableCamera.md)

**Signature**

```gdscript
func _update_target_tilt_from_z() -> void
```

## Description

Update camera tilt

## Source

```gdscript
func _update_target_tilt_from_z() -> void:
	var cz := bounds.position.z
	if _half_z <= 0.0:
		_target_tilt_rad = deg_to_rad(z_tilt_min_deg)
		return
	var z_min := cz - _half_z
	var z_max := cz + _half_z
	var t: float = clamp((camera.global_position.z - z_min) / (z_max - z_min), 0.0, 1.0)
	var target_deg: float = lerp(z_tilt_min_deg, z_tilt_max_deg, t)
	_target_tilt_rad = deg_to_rad(target_deg)
```
