# CodeEditAutocomplete::_on_code_completion_requested Function Reference

*Defined at:* `scripts/ui/CodeEditAutocomplete.gd` (lines 205–243)</br>
*Belongs to:* [CodeEditAutocomplete](../../CodeEditAutocomplete.md)

**Signature**

```gdscript
func _on_code_completion_requested() -> void
```

## Description

Handle code completion request from CodeEdit.

## Source

```gdscript
func _on_code_completion_requested() -> void:
	if not _code_edit:
		return

	# Add custom methods
	for method_name in custom_methods:
		var method_data: Dictionary = custom_methods[method_name]
		var params_str := ""
		if method_data.params.size() > 0:
			params_str = (
				method_data.params.reduce(func(acc, p): return acc + ", " + p, "").substr(2)
			)

		var display_text := "%s(%s)" % [method_name, params_str]
		var insert_text := "%s(" % method_name
		var tooltip := (
			"%s → %s\n\n%s" % [method_name, method_data.return_type, method_data.description]
		)

		_code_edit.add_code_completion_option(
			CodeEdit.KIND_FUNCTION, display_text, insert_text, AC_SUGGESTIONS_COLOR, null, tooltip
		)

	# Add base keywords
	for keyword in base_keywords:
		_code_edit.add_code_completion_option(
			CodeEdit.KIND_PLAIN_TEXT, keyword, keyword, Color.YELLOW
		)

	# Add built-in functions
	for func_name in builtin_functions:
		_code_edit.add_code_completion_option(
			CodeEdit.KIND_FUNCTION, func_name + "()", func_name + "(", Color.LIGHT_BLUE
		)

	# Update CodeEdit with completion options
	_code_edit.update_code_completion_options(true)
```
