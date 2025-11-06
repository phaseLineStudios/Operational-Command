# EnvironmentController::_update_lights Function Reference

*Defined at:* `scripts/sim/EnvironmentController.gd` (lines 54–66)</br>
*Belongs to:* [EnvironmentController](../../EnvironmentController.md)

**Signature**

```gdscript
func _update_lights() -> void
```

## Description

Update sun and moon based on current time of day

## Source

```gdscript
func _update_lights() -> void:
	sun_position = sun_root.global_position.y + 0.5
	moon_position = moon_root.global_position.y + 0.5
	sun.light_color = sky_preset.sun_light_color.gradient.sample(sun_position)
	sun.shadow_enabled = sun_shadow

	moon.light_color = sky_preset.moon_light_color.gradient.sample(sun_position)
	moon.shadow_enabled = moon_shadow

	sun.light_energy = clamp(sky_preset.sun_light_intensity.sample(sun_position), 0.0, 1.0)
	moon.light_energy = clamp(sky_preset.moon_light_intensity.sample(sun_position), 0.0, 1.0)
```
