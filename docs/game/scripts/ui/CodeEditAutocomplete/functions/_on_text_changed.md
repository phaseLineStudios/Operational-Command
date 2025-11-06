# CodeEditAutocomplete::_on_text_changed Function Reference

*Defined at:* `scripts/ui/CodeEditAutocomplete.gd` (lines 245–278)</br>
*Belongs to:* [CodeEditAutocomplete](../../CodeEditAutocomplete.md)

**Signature**

```gdscript
func _on_text_changed() -> void
```

## Description

Handle text changes to auto-trigger completion.

## Source

```gdscript
func _on_text_changed() -> void:
	if not _code_edit:
		return

	# Get the current line and caret column
	var line := _code_edit.get_caret_line()
	var column := _code_edit.get_caret_column()

	if column == 0:
		return

	var line_text := _code_edit.get_line(line)
	if column > line_text.length():
		return

	# Check if we just typed a trigger character
	var prev_char := line_text[column - 1] if column > 0 else ""
	if prev_char in auto_trigger_chars:
		_code_edit.request_code_completion()
		return

	# Auto-trigger after typing a certain number of characters
	var word_start := column - 1
	while word_start > 0 and line_text[word_start - 1].is_valid_identifier():
		word_start -= 1

	var word_length := column - word_start
	if word_length >= min_word_length:
		# Check if current word could match any suggestions
		var partial_word := line_text.substr(word_start, word_length)
		if _has_matching_suggestion(partial_word):
			_code_edit.request_code_completion()
```
