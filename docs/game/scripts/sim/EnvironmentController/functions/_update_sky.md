# EnvironmentController::_update_sky Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 147–231)</br>
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

	# Skip expensive shader updates if sun hasn't moved significantly
	if abs(sun_position - _cached_sun_position) < SUN_POSITION_THRESHOLD:
		return
	_cached_sun_position = sun_position

	var sky_material = self.environment.sky.get_material()
	var cloud_color = lerp(
		sky_preset.base_cloud_color.gradient.sample(sun_position),
		sky_preset.overcast_cloud_color.gradient.sample(sun_position),
		_set_cloud_coverage
	)

	sky_material.set_shader_parameter("b_anim_stars", animate_star_map)
	sky_material.set_shader_parameter("b_anim_clouds", animate_clouds)

	var base_sky_color: Color = sky_preset.base_sky_color.gradient.sample(sun_position)
	var darkened_sky_color := base_sky_color * _sky_brightness_modifier

	if rain_intensity > 0.0:
		var grey_amount := remap(rain_intensity, 0.0, 50.0, 0.0, 0.6)
		var luminance := (
			darkened_sky_color.r * 0.299
			+ darkened_sky_color.g * 0.587
			+ darkened_sky_color.b * 0.114
		)
		var grey_color := Color(luminance, luminance, luminance, darkened_sky_color.a)
		darkened_sky_color = darkened_sky_color.lerp(grey_color, grey_amount)

	sky_material.set_shader_parameter("base_color", darkened_sky_color)
	sky_material.set_shader_parameter("base_cloud_color", cloud_color)
	sky_material.set_shader_parameter("horizon_size", sky_preset.horizon_size)
	sky_material.set_shader_parameter("horizon_alpha", sky_preset.horizon_alpha)

	var base_horizon_color: Color = sky_preset.horizon_fog_color.gradient.sample(sun_position)
	var darkened_horizon_color := base_horizon_color * _sky_brightness_modifier
	sky_material.set_shader_parameter("horizon_fog_color", darkened_horizon_color)

	sky_material.set_shader_parameter("cloud_type", 1)

	sky_material.set_shader_parameter("cloud_density", sky_preset.cloud_density)
	sky_material.set_shader_parameter("mg_size", sky_preset.cloud_glow)
	sky_material.set_shader_parameter("cloud_speed", sky_preset.cloud_speed)
	sky_material.set_shader_parameter("cloud_direction", sky_preset.cloud_direction)
	sky_material.set_shader_parameter("cloud_coverage", _set_cloud_coverage)
	sky_material.set_shader_parameter("absorption", sky_preset.cloud_light_absorbtion)
	sky_material.set_shader_parameter("henyey_greenstein_level", sky_preset.anisotropy)
	sky_material.set_shader_parameter("cloud_edge", sky_preset.cloud_edge)
	var adjusted_brightness := sky_preset.cloud_brightness * _cloud_brightness_modifier
	sky_material.set_shader_parameter("dynamic_cloud_brightness", adjusted_brightness)
	sky_material.set_shader_parameter("horizon_uv_curve", sky_preset.cloud_uv_curvature)

	sky_material.set_shader_parameter("sun_radius", sky_preset.sun_radius)
	sky_material.set_shader_parameter(
		"sun_disc_color", sky_preset.sun_disc_color.gradient.sample(sun_position)
	)
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
