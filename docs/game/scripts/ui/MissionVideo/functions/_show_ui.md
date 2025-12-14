# MissionVideo::_show_ui Function Reference

*Defined at:* `scripts/ui/MissionVideo.gd` (lines 78–84)</br>
*Belongs to:* [MissionVideo](../../MissionVideo.md)

**Signature**

```gdscript
func _show_ui() -> void
```

## Source

```gdscript
func _show_ui() -> void:
	if _ui_hidden:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		hold_label.visible = true
		_ui_hidden = false
```
