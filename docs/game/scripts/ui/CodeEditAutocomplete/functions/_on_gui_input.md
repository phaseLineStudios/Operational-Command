# CodeEditAutocomplete::_on_gui_input Function Reference

*Defined at:* `scripts/ui/CodeEditAutocomplete.gd` (lines 280–296)</br>
*Belongs to:* [CodeEditAutocomplete](../../CodeEditAutocomplete.md)

**Signature**

```gdscript
func _on_gui_input(event: InputEvent) -> void
```

## Description

Handle keyboard input for manual completion trigger (Ctrl+Space).

## Source

```gdscript
func _on_gui_input(event: InputEvent) -> void:
	if not _code_edit:
		return

	if event is InputEventKey:
		var key_event := event as InputEventKey
		# Ctrl+Space or Ctrl+Shift+Space to trigger completion
		if (
			key_event.pressed
			and not key_event.echo
			and key_event.keycode == KEY_SPACE
			and key_event.ctrl_pressed
		):
			_code_edit.request_code_completion()
			_code_edit.accept_event()
```
