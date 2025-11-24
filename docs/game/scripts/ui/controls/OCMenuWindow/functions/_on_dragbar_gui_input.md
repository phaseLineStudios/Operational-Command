# OCMenuWindow::_on_dragbar_gui_input Function Reference

*Defined at:* `scripts/ui/controls/OcMenuWindow.gd` (lines 104–131)</br>
*Belongs to:* [OCMenuWindow](../../OCMenuWindow.md)

**Signature**

```gdscript
func _on_dragbar_gui_input(event: InputEvent) -> void
```

- **event**: GUI input event from the drag bar.

## Description

Handles mouse input on the drag bar to drag the window.

## Source

```gdscript
func _on_dragbar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton

		if mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				var parent_control := get_parent() as Control
				if parent_control != null:
					_is_dragging = true
					_drag_offset = parent_control.get_local_mouse_position() - position
				accept_event()
			else:
				_is_dragging = false
				accept_event()

	elif event is InputEventMouseMotion and _is_dragging:
		var mm := event as InputEventMouseMotion
		var parent_control := get_parent() as Control

		if parent_control != null:
			var mouse_parent := parent_control.get_local_mouse_position()
			position = (mouse_parent - _drag_offset).round()
		else:
			position += mm.relative.round()

		accept_event()
```
