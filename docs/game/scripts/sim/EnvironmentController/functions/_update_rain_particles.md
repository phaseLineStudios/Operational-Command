# EnvironmentController::_update_rain_particles Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 316–348)</br>
*Belongs to:* [EnvironmentController](../../EnvironmentController.md)

**Signature**

```gdscript
func _update_rain_particles() -> void
```

## Description

Internal: Update rain particle system based on intensity

## Source

```gdscript
func _update_rain_particles() -> void:
	if rain_node == null:
		return

	if rain_intensity <= 0.0:
		rain_node.emitting = false
		return

	rain_node.emitting = true

	var amount := int(remap(rain_intensity, 0.0, 50.0, 100.0, 5000.0))
	rain_node.amount = amount

	var lifetime := remap(rain_intensity, 0.0, 50.0, 2.0, 0.8)
	rain_node.lifetime = lifetime

	var speed_scale := remap(rain_intensity, 0.0, 50.0, 0.8, 2.0)
	rain_node.speed_scale = speed_scale

	var process_mat := rain_node.process_material as ParticleProcessMaterial
	if process_mat:
		var gravity := remap(rain_intensity, 0.0, 50.0, -9.8, -20.0)

		var base_velocity := remap(rain_intensity, 0.0, 50.0, 2.0, 8.0)
		process_mat.initial_velocity_min = base_velocity * 0.95
		process_mat.initial_velocity_max = base_velocity * 1.05

		var wind_rad := deg_to_rad(wind_direction)
		var wind_x := -sin(wind_rad) * wind_speed * 0.02
		var wind_z := cos(wind_rad) * wind_speed * 0.02
		process_mat.gravity = Vector3(wind_x, gravity, wind_z)
```
