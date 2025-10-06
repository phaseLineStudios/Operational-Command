# ActionRebindButton::_unhandled_input Function Reference

*Defined at:* `scripts/ui/helpers/ActionRebindButton.gd` (lines 41–58)</br>
*Belongs to:* [ActionRebindButton](../ActionRebindButton.md)

**Signature**

```gdscript
func _unhandled_input(event: InputEvent) -> void
```

## Description

Capture input and assign.

## Source

```gdscript
func _unhandled_input(event: InputEvent) -> void:
	if not _capturing:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		# Clear binding
		InputMap.action_erase_events(action_name)
		_capturing = false
		refresh_label()
		accept_event()
		return

	if event.is_pressed():
		# Only allow one primary binding (simple).
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, event)
		_capturing = false
		refresh_label()
		accept_event()
```
