# CodeEditAutocomplete::_setup_syntax_highlighting Function Reference

*Defined at:* `scripts/ui/CodeEditAutocomplete.gd` (lines 323–339)</br>
*Belongs to:* [CodeEditAutocomplete](../../CodeEditAutocomplete.md)

**Signature**

```gdscript
func _setup_syntax_highlighting() -> void
```

## Description

Setup syntax highlighting for GDScript.

## Source

```gdscript
func _setup_syntax_highlighting() -> void:
	if not _code_edit:
		return

	# Enable syntax highlighting
	_code_edit.syntax_highlighter = _create_gdscript_highlighter()

	# Set editor colors
	_code_edit.add_theme_color_override("background_color", COLOR_BACKGROUND)
	_code_edit.add_theme_color_override("current_line_color", COLOR_BACKGROUND_SELECTED)
	_code_edit.add_theme_color_override("line_number_color", COLOR_LINE_NUMBER)
	_code_edit.add_theme_color_override("caret_color", COLOR_CARET)
	_code_edit.add_theme_color_override("caret_background_color", COLOR_BACKGROUND)
	_code_edit.add_theme_color_override("word_highlighted_color", COLOR_BACKGROUND_SELECTED)
	_code_edit.add_theme_color_override("selection_color", COLOR_BACKGROUND_SELECTED)
```
