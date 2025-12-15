# PostProcessController::_restore_video_state Function Reference

*Defined at:* `scripts/ui/PostProcessController.gd` (lines 229–254)</br>
*Belongs to:* [PostProcessController](../../PostProcessController.md)

**Signature**

```gdscript
func _restore_video_state() -> void
```

## Source

```gdscript
func _restore_video_state() -> void:
	if _saved_video.is_empty():
		return
	var window: Window = get_window()
	if window:
		window.content_scale_mode = (
			int(_saved_video.get("content_scale_mode", window.content_scale_mode))
			as Window.ContentScaleMode
		)
		window.content_scale_aspect = (
			int(_saved_video.get("content_scale_aspect", window.content_scale_aspect))
			as Window.ContentScaleAspect
		)
		window.content_scale_size = _saved_video.get(
			"content_scale_size", window.content_scale_size
		)
	var root_vp := get_tree().root
	if root_vp:
		root_vp.scaling_3d_mode = (
			int(_saved_video.get("scaling_3d_mode", root_vp.scaling_3d_mode))
			as Viewport.Scaling3DMode
		)
		root_vp.scaling_3d_scale = float(
			_saved_video.get("scaling_3d_scale", root_vp.scaling_3d_scale)
		)
	_saved_video.clear()
```
