# TerrainEditor::_unhandled_key_input Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 318–340)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func _unhandled_key_input(event)
```

## Description

Handle unhandled input

## Source

```gdscript
func _unhandled_key_input(event):
	if active_tool and active_tool.handle_view_input(event):
		return

	if event is InputEventKey and event.pressed:
		var ctrl: bool = event.ctrl_pressed or event.meta_pressed
		if ctrl and event.keycode == KEY_Z:
			history.undo()
			accept_event()
		elif ctrl and (event.keycode == KEY_Y or (event.shift_pressed and event.keycode == KEY_Z)):
			history.redo()
			accept_event()
		elif ctrl and event.keycode == KEY_S:
			if event.shift_pressed:
				_save_as()
			else:
				_save()
			accept_event()
		elif ctrl and event.keycode == KEY_O:
			_open()
			accept_event()
```
