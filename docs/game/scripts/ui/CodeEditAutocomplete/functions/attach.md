# CodeEditAutocomplete::attach Function Reference

*Defined at:* `scripts/ui/CodeEditAutocomplete.gd` (lines 156–186)</br>
*Belongs to:* [CodeEditAutocomplete](../../CodeEditAutocomplete.md)

**Signature**

```gdscript
func attach(code_edit: CodeEdit, enable_syntax_highlighting: bool = true) -> void
```

- **code_edit**: CodeEdit node to attach to.
- **enable_syntax_highlighting**: If true, applies syntax highlighting (default: true).

## Description

Attach autocomplete to a CodeEdit node.

## Source

```gdscript
func attach(code_edit: CodeEdit, enable_syntax_highlighting: bool = true) -> void:
	if _code_edit:
		detach()

	_code_edit = code_edit
	if not _code_edit:
		return

	# Connect to completion request signal
	if not _code_edit.code_completion_requested.is_connected(_on_code_completion_requested):
		_code_edit.code_completion_requested.connect(_on_code_completion_requested)

	# Connect to text_changed for auto-triggering
	if not _code_edit.text_changed.is_connected(_on_text_changed):
		_code_edit.text_changed.connect(_on_text_changed)

	# Connect to gui_input for manual triggering (Ctrl+Space)
	if not _code_edit.gui_input.is_connected(_on_gui_input):
		_code_edit.gui_input.connect(_on_gui_input)

	# Ensure code completion is enabled
	_code_edit.code_completion_enabled = true

	# Set code completion prefixes (characters that can trigger completion)
	_code_edit.code_completion_prefixes = auto_trigger_chars

	# Setup syntax highlighting
	if enable_syntax_highlighting:
		_setup_syntax_highlighting()
```
