# DebugMetricsDisplay::update_settings_label Function Reference

*Defined at:* `scripts/ui/DebugMetricsDisplay.gd` (lines 126–232)</br>
*Belongs to:* [DebugMetricsDisplay](../DebugMetricsDisplay.md)

**Signature**

```gdscript
func update_settings_label() -> void
```

## Description

Update hardware information label

## Source

```gdscript
func update_settings_label() -> void:
	settings.text = ""
	if ProjectSettings.has_setting("application/config/version"):
		settings.text += (
			"Project Version: %s\n" % ProjectSettings.get_setting("application/config/version")
		)

	var rendering_method := str(
		ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method")
	)
	var rendering_method_string := rendering_method
	match rendering_method:
		"forward_plus":
			rendering_method_string = "Forward+"
		"mobile":
			rendering_method_string = "Forward Mobile"
		"gl_compatibility":
			rendering_method_string = "Compatibility"
	settings.text += "Rendering Method: %s\n" % rendering_method_string

	var viewport := get_viewport()

	var viewport_render_size := Vector2i()

	if viewport.content_scale_mode == Window.CONTENT_SCALE_MODE_VIEWPORT:
		viewport_render_size = viewport.get_visible_rect().size
		settings.text += (
			"Viewport: %d×%d, Window: %d×%d\n"
			% [
				viewport.get_visible_rect().size.x,
				viewport.get_visible_rect().size.y,
				viewport.size.x,
				viewport.size.y
			]
		)
	else:
		viewport_render_size = viewport.size
		settings.text += "Viewport: %d×%d\n" % [viewport.size.x, viewport.size.y]

	if viewport.get_camera_3d():
		var scaling_3d_mode_string := "(unknown)"
		match viewport.scaling_3d_mode:
			Viewport.SCALING_3D_MODE_BILINEAR:
				scaling_3d_mode_string = "Bilinear"
			Viewport.SCALING_3D_MODE_FSR:
				scaling_3d_mode_string = "FSR 1.0"
			Viewport.SCALING_3D_MODE_FSR2:
				scaling_3d_mode_string = "FSR 2.2"

		var antialiasing_3d_string := ""
		if viewport.scaling_3d_mode == Viewport.SCALING_3D_MODE_FSR2:
			antialiasing_3d_string += (
				(" + " if not antialiasing_3d_string.is_empty() else "") + "FSR 2.2"
			)
		if viewport.scaling_3d_mode != Viewport.SCALING_3D_MODE_FSR2 and viewport.use_taa:
			antialiasing_3d_string += (
				(" + " if not antialiasing_3d_string.is_empty() else "") + "TAA"
			)
		if viewport.msaa_3d >= Viewport.MSAA_2X:
			antialiasing_3d_string += (
				(" + " if not antialiasing_3d_string.is_empty() else "")
				+ "%d× MSAA" % pow(2, viewport.msaa_3d)
			)
		if viewport.screen_space_aa == Viewport.SCREEN_SPACE_AA_FXAA:
			antialiasing_3d_string += (
				(" + " if not antialiasing_3d_string.is_empty() else "") + "FXAA"
			)

		settings.text += (
			"3D scale (%s): %d%% = %d×%d"
			% [
				scaling_3d_mode_string,
				viewport.scaling_3d_scale * 100,
				viewport_render_size.x * viewport.scaling_3d_scale,
				viewport_render_size.y * viewport.scaling_3d_scale,
			]
		)

		if not antialiasing_3d_string.is_empty():
			settings.text += "\n3D Antialiasing: %s" % antialiasing_3d_string

		var environment := viewport.get_camera_3d().get_world_3d().environment
		if environment:
			if environment.ssr_enabled:
				settings.text += "\nSSR: %d Steps" % environment.ssr_max_steps

			if environment.ssao_enabled:
				settings.text += "\nSSAO: On"
			if environment.ssil_enabled:
				settings.text += "\nSSIL: On"

			if environment.sdfgi_enabled:
				settings.text += "\nSDFGI: %d Cascades" % environment.sdfgi_cascades

			if environment.glow_enabled:
				settings.text += "\nGlow: On"

			if environment.volumetric_fog_enabled:
				settings.text += "\nVolumetric Fog: On"
	var antialiasing_2d_string := ""
	if viewport.msaa_2d >= Viewport.MSAA_2X:
		antialiasing_2d_string = "%d× MSAA" % pow(2, viewport.msaa_2d)

	if not antialiasing_2d_string.is_empty():
		settings.text += "\n2D Antialiasing: %s" % antialiasing_2d_string
```
