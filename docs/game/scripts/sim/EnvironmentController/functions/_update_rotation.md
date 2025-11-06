# EnvironmentController::_update_rotation Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 68–73)</br>
*Belongs to:* [EnvironmentController](../../EnvironmentController.md)

**Signature**

```gdscript
func _update_rotation() -> void
```

## Description

Update rotation of sun and moon

## Source

```gdscript
func _update_rotation() -> void:
	var hour_mapped := remap(time_of_day, 0.0, 86400.0, 0.0, 1.0)
	sun_moon_parent.rotation_degrees.y = sky_rotation
	sun_moon_parent.rotation_degrees.x = hour_mapped * 360.0
```
