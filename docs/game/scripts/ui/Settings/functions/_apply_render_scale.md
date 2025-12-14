# Settings::_apply_render_scale Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 301–337)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _apply_render_scale() -> void
```

## Description

Apply 3D render scaling to keep performance stable at higher resolutions.

## Source

```gdscript
func _apply_render_scale() -> void:
	var root_viewport := get_tree().root
	if root_viewport == null:
		return

	var window: Window = get_window()
	var window_size: Vector2i = window.size if window != null else Vector2i.ZERO
	if window_size.x <= 0 or window_size.y <= 0:
		window_size = root_viewport.size

	var target_size: Vector2i = window_size
	var idx := _res.get_selected()
	if idx >= 0 and idx < resolutions.size():
		target_size = resolutions[idx]

	# Lock the internal render resolution to the selected resolution and scale the final
	# output to the window. This avoids large performance swings when resizing.
	var content_size: Vector2i = _compute_content_scale_size(window_size, target_size)
	if window != null:
		window.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
		window.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
		window.content_scale_size = content_size

	var user_scale: float = clampf(float(_scale.value) / 100.0, 0.1, 2.0)
	var final_scale: float = user_scale

	# Godot 4 exposes scaling modes but no explicit "disabled" enum;
	# use bilinear at scale 1.0 to behave like "off".
	var mode: int = Viewport.SCALING_3D_MODE_BILINEAR
	if final_scale < 0.999:
		mode = Viewport.SCALING_3D_MODE_FSR
	root_viewport.scaling_3d_mode = mode
	root_viewport.scaling_3d_scale = final_scale

	_apply_adaptive_aa(root_viewport, content_size, final_scale)
```
