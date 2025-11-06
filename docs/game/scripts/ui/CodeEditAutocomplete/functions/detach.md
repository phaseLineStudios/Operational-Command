# CodeEditAutocomplete::detach Function Reference

*Defined at:* `scripts/ui/CodeEditAutocomplete.gd` (lines 188–203)</br>
*Belongs to:* [CodeEditAutocomplete](../../CodeEditAutocomplete.md)

**Signature**

```gdscript
func detach() -> void
```

## Description

Detach from current CodeEdit node.

## Source

```gdscript
func detach() -> void:
	if not _code_edit:
		return

	if _code_edit.code_completion_requested.is_connected(_on_code_completion_requested):
		_code_edit.code_completion_requested.disconnect(_on_code_completion_requested)

	if _code_edit.text_changed.is_connected(_on_text_changed):
		_code_edit.text_changed.disconnect(_on_text_changed)

	if _code_edit.gui_input.is_connected(_on_gui_input):
		_code_edit.gui_input.disconnect(_on_gui_input)

	_code_edit = null
```
