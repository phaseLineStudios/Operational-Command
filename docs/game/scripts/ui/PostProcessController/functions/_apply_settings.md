# PostProcessController::_apply_settings Function Reference

*Defined at:* `scripts/ui/PostProcessController.gd` (lines 73–99)</br>
*Belongs to:* [PostProcessController](../../PostProcessController.md)

**Signature**

```gdscript
func _apply_settings() -> void
```

## Description

apply parameters.

## Source

```gdscript
func _apply_settings() -> void:
	environment.tonemap_mode = Environment.TONE_MAPPER_ACES
	environment.adjustment_enabled = true
	environment.adjustment_brightness = adjustment_brightness
	environment.adjustment_contrast = adjustment_contrast
	environment.adjustment_saturation = adjustment_saturation
	environment.adjustment_color_correction = lut_texture

	environment.ssao_enabled = ssao
	environment.ssr_enabled = ssr

	environment.glow_enabled = glow
	environment.glow_intensity = glow_intensity
	environment.glow_bloom = glow_bloom

	film_grain_shader.set_shader_parameter("grain_amount", grain_amount)
	film_grain_shader.set_shader_parameter("grain_size", grain_size)

	general_shader.set_shader_parameter("vignette", vignette)
	general_shader.set_shader_parameter("vignette_intensity", vignette_intensity)
	general_shader.set_shader_parameter("vignette_softness", vignette_softness)
	general_shader.set_shader_parameter("chromatic_abberation", ca)
	general_shader.set_shader_parameter("ca_intensity", ca_intensity)
	general_shader.set_shader_parameter("sharpen", sharpen)
	general_shader.set_shader_parameter("sharpen_strength", sharpen_strength)
```
