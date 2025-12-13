# MissionVideo::_hide_ui Function Reference

*Defined at:* `scripts/ui/MissionVideo.gd` (lines 85–93)</br>
*Belongs to:* [MissionVideo](../../MissionVideo.md)

**Signature**

```gdscript
func _hide_ui() -> void
```

## Source

```gdscript
func _hide_ui() -> void:
	if not _ui_hidden:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		hold_label.visible = false
		if _space_hold_time == 0.0:
			hold_progress.visible = false
		_ui_hidden = true
```
