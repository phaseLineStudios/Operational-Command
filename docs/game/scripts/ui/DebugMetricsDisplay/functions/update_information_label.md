# DebugMetricsDisplay::update_information_label Function Reference

*Defined at:* `scripts/ui/DebugMetricsDisplay.gd` (lines 234–312)</br>
*Belongs to:* [DebugMetricsDisplay](../DebugMetricsDisplay.md)

**Signature**

```gdscript
func update_information_label() -> void
```

## Description

Update hardware/software information label

## Source

```gdscript
func update_information_label() -> void:
	var adapter_string := ""
	if (
		RenderingServer.get_video_adapter_vendor().trim_suffix(" Corporation")
		in RenderingServer.get_video_adapter_name()
	):
		adapter_string = RenderingServer.get_video_adapter_name().trim_suffix("/PCIe/SSE2")
	else:
		adapter_string = (
			RenderingServer.get_video_adapter_vendor()
			+ " - "
			+ RenderingServer.get_video_adapter_name().trim_suffix("/PCIe/SSE2")
		)

	var driver_info := OS.get_video_adapter_driver_info()
	var driver_info_string := ""
	if driver_info.size() >= 2:
		driver_info_string = driver_info[1]
	else:
		driver_info_string = "(unknown)"

	var release_string := ""
	if OS.has_feature("editor"):
		release_string = "editor"
	elif OS.has_feature("debug"):
		release_string = "debug"
	else:
		release_string = "release"

	var rendering_method := str(
		ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method")
	)
	var rendering_driver := str(
		ProjectSettings.get_setting_with_override("rendering/rendering_device/driver")
	)
	var graphics_api_string := rendering_driver
	if rendering_method != "gl_compatibility":
		if rendering_driver == "d3d12":
			graphics_api_string = "Direct3D 12"
		elif rendering_driver == "metal":
			graphics_api_string = "Metal"
		elif rendering_driver == "vulkan":
			if OS.has_feature("macos") or OS.has_feature("ios"):
				graphics_api_string = "Vulkan via MoltenVK"
			else:
				graphics_api_string = "Vulkan"
	else:
		if rendering_driver == "opengl3_angle":
			graphics_api_string = "OpenGL via ANGLE"
		elif OS.has_feature("mobile") or rendering_driver == "opengl3_es":
			graphics_api_string = "OpenGL ES"
		elif OS.has_feature("web"):
			graphics_api_string = "WebGL"
		elif rendering_driver == "opengl3":
			graphics_api_string = "OpenGL"

	information.text = (
		(
			"%s, %d threads\n"
			% [
				OS.get_processor_name().replace("(R)", "").replace("(TM)", ""),
				OS.get_processor_count()
			]
		)
		+ (
			"%s %s (%s %s), %s %s\n"
			% [
				OS.get_name(),
				"64-bit" if OS.has_feature("64") else "32-bit",
				release_string,
				"double" if OS.has_feature("double") else "single",
				graphics_api_string,
				RenderingServer.get_video_adapter_api_version()
			]
		)
		+ "%s, %s" % [adapter_string, driver_info_string]
	)
```
