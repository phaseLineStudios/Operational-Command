# PostProcessController::_apply_video_full_res Function Reference

*Defined at:* `scripts/ui/PostProcessController.gd` (lines 215–228)</br>
*Belongs to:* [PostProcessController](../../PostProcessController.md)

**Signature**

```gdscript
func _apply_video_full_res() -> void
```

## Source

```gdscript
func _apply_video_full_res() -> void:
	var window: Window = get_window()
	var root_vp := get_tree().root
	if window == null or root_vp == null:
		return

	# Keep the same scale mode but render at native window resolution for readability.
	if window.size.x > 0 and window.size.y > 0:
		window.content_scale_size = window.size

	root_vp.scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
	root_vp.scaling_3d_scale = 1.0
```
