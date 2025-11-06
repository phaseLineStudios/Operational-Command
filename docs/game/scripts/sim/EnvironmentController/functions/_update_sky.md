# EnvironmentController::_update_sky Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 75–140)</br>
*Belongs to:* [EnvironmentController](../../EnvironmentController.md)

**Signature**

```gdscript
func _update_sky() -> void
```

## Description

Update colors based on current time of day

## Source

```gdscript
func _update_sky() -> void:
	sun_position = sun_root.global_position.y / 2.0 + 0.5

	var sky_material = self.environment.sky.get_material()
	var cloud_color = lerp(
		sky_preset.base_cloud_color.gradient.sample(sun_position),
		sky_preset.overcast_sky_color.gradient.sample(sun_position),
		cloud_coverage
	)

	sky_material.set_shader_parameter("b_anim_stars", animate_star_map)
	sky_material.set_shader_parameter("b_anim_clouds", animate_clouds)

	sky_material.set_shader_parameter(
		"base_color", sky_preset.base_sky_color.gradient.sample(sun_position)
	)
	sky_material.set_shader_parameter("base_cloud_color", cloud_color)
	sky_material.set_shader_parameter("horizon_size", sky_preset.horizon_size)
	sky_material.set_shader_parameter("horizon_alpha", sky_preset.horizon_alpha)
	sky_material.set_shader_parameter(
		"horizon_fog_color", sky_preset.horizon_fog_color.gradient.sample(sun_position)
	)

	sky_material.set_shader_parameter("cloud_density", sky_preset.cloud_density)
	sky_material.set_shader_parameter("mg_size", sky_preset.cloud_glow)
	sky_material.set_shader_parameter("cloud_speed", sky_preset.cloud_speed)
	sky_material.set_shader_parameter("cloud_direction", sky_preset.cloud_direction)
	sky_material.set_shader_parameter("cloud_coverage", cloud_coverage)
	sky_material.set_shader_parameter("absorption", sky_preset.cloud_light_absorbtion)
	sky_material.set_shader_parameter("henyey_greenstein_level", sky_preset.anisotropy)
	sky_material.set_shader_parameter("cloud_edge", sky_preset.cloud_edge)
	sky_material.set_shader_parameter("dynamic_cloud_brightness", sky_preset.cloud_brightness)
	sky_material.set_shader_parameter("horizon_uv_curve", sky_preset.cloud_uv_curvature)

	sky_material.set_shader_parameter("sun_radius", sky_preset.sun_radius)
	sky_material.set_shader_parameter(
		"sun_disc_color", sky_preset.sun_disc_color.gradient.sample(sun_position)
	)
	sky_material.set_shader_parameter("sun_glow_color", sky_preset.sun_glow)
	sky_material.set_shader_parameter(
		"sun_glow_color", sky_preset.sun_glow.gradient.sample(sun_position)
	)
	sky_material.set_shader_parameter("sun_edge_blur", sky_preset.sun_edge_blur)
	sky_material.set_shader_parameter("sun_glow_intensity", sky_preset.sun_glow_intensity)
	sky_material.set_shader_parameter(
		"sunlight_color", sky_preset.sun_light_color.gradient.sample(sun_position)
	)

	sky_material.set_shader_parameter("moon_radius", sky_preset.moon_radius)
	sky_material.set_shader_parameter(
		"moon_glow_color", sky_preset.moon_glow_color.gradient.sample(sun_position)
	)
	sky_material.set_shader_parameter("moon_edge_blur", sky_preset.moon_edge_blur)
	sky_material.set_shader_parameter("moon_glow_intensity", sky_preset.moon_glow_intensity)
	sky_material.set_shader_parameter(
		"moon_light_color", sky_preset.moon_light_color.gradient.sample(sun_position)
	)

	sky_material.set_shader_parameter("star_color", sky_preset.star_color)
	sky_material.set_shader_parameter("star_brightness", sky_preset.star_brightness)
	sky_material.set_shader_parameter("twinkle_speed", sky_preset.twinkle_speed)
	sky_material.set_shader_parameter("twinkle_scale", sky_preset.twinkle_scale)
	sky_material.set_shader_parameter("star_resolution", sky_preset.star_resolution)
	sky_material.set_shader_parameter("star_speed", sky_preset.star_speed)
```
