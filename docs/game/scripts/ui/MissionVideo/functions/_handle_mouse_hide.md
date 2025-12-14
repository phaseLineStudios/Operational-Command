# MissionVideo::_handle_mouse_hide Function Reference

*Defined at:* `scripts/ui/MissionVideo.gd` (lines 63–77)</br>
*Belongs to:* [MissionVideo](../../MissionVideo.md)

**Signature**

```gdscript
func _handle_mouse_hide(delta: float) -> void
```

## Source

```gdscript
func _handle_mouse_hide(delta: float) -> void:
	if not get_viewport():
		return
	var current_mouse_pos := get_viewport().get_mouse_position()

	if current_mouse_pos != _last_mouse_pos:
		_last_mouse_pos = current_mouse_pos
		_hide_timer = 0.0
		_show_ui()
	else:
		_hide_timer += delta
		if _hide_timer >= MOUSE_HIDE_DELAY and not _ui_hidden:
			_hide_ui()
```
