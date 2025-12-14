# EnvironmentController::_update_wind_effects Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 384–401)</br>
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
			var wind_rad := deg_to_rad(wind_direction)
			var wind_x := -sin(wind_rad) * wind_speed * 0.1
			var wind_z := cos(wind_rad) * wind_speed * 0.1

			process_mat.direction = Vector3(wind_x, -1, wind_z).normalized()

	if sky_preset != null:
		var cloud_speed: float = wind_speed * 0.001
		sky_preset.cloud_speed = clamp(cloud_speed, 0.0, 10.0)

		var wind_rad := deg_to_rad(wind_direction)
		sky_preset.cloud_direction = Vector2(sin(wind_rad), -cos(wind_rad))
```
