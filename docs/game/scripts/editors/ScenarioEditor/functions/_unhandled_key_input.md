# ScenarioEditor::_unhandled_key_input Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 392–422)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _unhandled_key_input(event)
```

## Description

Global key handling: delete, undo/redo, and tool input

## Source

```gdscript
func _unhandled_key_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_DELETE:
		if not ctx.selected_pick.is_empty():
			deletion_ops.delete_pick(ctx.selected_pick)
			get_viewport().set_input_as_handled()
			return
	if event is InputEventKey and event.pressed:
		if event.ctrl_pressed and event.keycode == KEY_S:
			file_ops.cmd_save()
			get_viewport().set_input_as_handled()
			return
		if event.ctrl_pressed and event.keycode == KEY_O:
			file_ops.cmd_open()
			get_viewport().set_input_as_handled()
			return
		if event.ctrl_pressed and event.keycode == KEY_Z:
			if history:
				history.undo()
				generic_notification("Undo", 1, false)
			get_viewport().set_input_as_handled()
			return
		if event.ctrl_pressed and event.keycode == KEY_Y:
			if history:
				history.redo()
				generic_notification("Redo", 1, false)
			get_viewport().set_input_as_handled()
			return
	if ctx.current_tool and ctx.current_tool.handle_input(event):
		return
```
