# UnitCounterController::_on_drawer_input_event Function Reference

*Defined at:* `scripts/sim/UnitCounterController.gd` (lines 44–52)</br>
*Belongs to:* [UnitCounterController](../../UnitCounterController.md)

**Signature**

```gdscript
func _on_drawer_input_event(_cam, event: InputEvent, _pos, _norm, _shape_idx) -> void
```

- **_cam**: Unused camera reference.
- **event**: The input event to check for mouse clicks.
- **_pos**: Unused hit position.
- **_norm**: Unused hit normal.
- **_shape_idx**: Unused shape index.

## Description

Handles click on the drawer and pops the dialog.

## Source

```gdscript
func _on_drawer_input_event(_cam, event: InputEvent, _pos, _norm, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if counter_dialog:
			counter_dialog.popup_centered()
			counter_dialog.grab_focus()
		else:
			push_warning("unitCounterController: 'counter_dialog' is not assigned.")
```
