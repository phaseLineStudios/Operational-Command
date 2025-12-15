# MissionDialog::_on_drag_bar_input Function Reference

*Defined at:* `scripts/ui/MissionDialog.gd` (lines 217–233)</br>
*Belongs to:* [MissionDialog](../../MissionDialog.md)

**Signature**

```gdscript
func _on_drag_bar_input(event: InputEvent) -> void
```

## Description

Handle drag bar input for dragging the dialog

## Source

```gdscript
func _on_drag_bar_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				# Start dragging
				_dragging = true
				_drag_offset = _center_container.global_position - get_global_mouse_position()
			else:
				# Stop dragging
				_dragging = false
	elif event is InputEventMouseMotion and _dragging:
		# Update dialog position while dragging
		if _center_container:
			# Switch to manual positioning
			_center_container.set_anchors_preset(Control.PRESET_TOP_LEFT)
			_center_container.position = get_global_mouse_position() + _drag_offset
```
