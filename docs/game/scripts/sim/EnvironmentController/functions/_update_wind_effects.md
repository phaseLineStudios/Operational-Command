# EnvironmentController::_update_wind_effects Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 391–406)</br>
*Belongs to:* [EnvironmentController](../../EnvironmentController.md)

**Signature**

```gdscript
func _update_wind_effects() -> void
```

## Description

Internal: Update wind effects on particles and clouds

## Source

```gdscript
func _update_wind_effects() -> void:
	if rain_node != null:
		var process_mat := rain_node.process_material as ParticleProcessMaterial
		if process_mat:
			process_mat.direction = Vector3(0, -1, 0)

	_update_rain_particles()

	if sky_preset != null:
		var cloud_speed: float = wind_speed * 0.001
		sky_preset.cloud_speed = clamp(cloud_speed, 0.0, 10.0)

		var wind_rad := deg_to_rad(wind_direction)
		sky_preset.cloud_direction = Vector2(sin(wind_rad), -cos(wind_rad))
```
