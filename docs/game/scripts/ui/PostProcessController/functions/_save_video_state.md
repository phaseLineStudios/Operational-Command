# PostProcessController::_save_video_state Function Reference

*Defined at:* `scripts/ui/PostProcessController.gd` (lines 202–214)</br>
*Belongs to:* [PostProcessController](../../PostProcessController.md)

**Signature**

```gdscript
func _save_video_state() -> void
```

## Source

```gdscript
func _save_video_state() -> void:
	_saved_video.clear()
	var window: Window = get_window()
	if window:
		_saved_video["content_scale_mode"] = int(window.content_scale_mode)
		_saved_video["content_scale_aspect"] = int(window.content_scale_aspect)
		_saved_video["content_scale_size"] = window.content_scale_size
	var root_vp := get_tree().root
	if root_vp:
		_saved_video["scaling_3d_mode"] = int(root_vp.scaling_3d_mode)
		_saved_video["scaling_3d_scale"] = float(root_vp.scaling_3d_scale)
```
