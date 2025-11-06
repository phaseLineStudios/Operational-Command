# CodeEditAutocomplete::_create_gdscript_highlighter Function Reference

*Defined at:* `scripts/ui/CodeEditAutocomplete.gd` (lines 341–394)</br>
*Belongs to:* [CodeEditAutocomplete](../../CodeEditAutocomplete.md)

**Signature**

```gdscript
func _create_gdscript_highlighter() -> CodeHighlighter
```

## Description

Create a GDScript syntax highlighter.

## Source

```gdscript
func _create_gdscript_highlighter() -> CodeHighlighter:
	var highlighter := CodeHighlighter.new()

	# Add number color
	highlighter.number_color = COLOR_NUMBER

	# Add symbol color
	highlighter.symbol_color = COLOR_SYMBOL

	# Add function color
	highlighter.function_color = COLOR_FUNCTION

	# Add member variable color
	highlighter.member_variable_color = COLOR_MEMBER

	# Add keywords with different colors for different types
	var control_flow_keywords := [
		"if", "elif", "else", "for", "while", "match", "break", "continue", "pass", "return"
	]
	for keyword in control_flow_keywords:
		highlighter.add_keyword_color(keyword, COLOR_CONTROL_FLOW)

	var declaration_keywords := ["var", "const", "func", "class", "extends", "signal", "enum"]
	for keyword in declaration_keywords:
		highlighter.add_keyword_color(keyword, COLOR_KEYWORD)

	var boolean_keywords := ["true", "false", "null"]
	for keyword in boolean_keywords:
		highlighter.add_keyword_color(keyword, COLOR_NUMBER)

	var operator_keywords := ["and", "or", "not", "in", "is"]
	for keyword in operator_keywords:
		highlighter.add_keyword_color(keyword, COLOR_CONTROL_FLOW)

	var other_keywords := ["await", "super", "self", "as", "get", "set", "static"]
	for keyword in other_keywords:
		highlighter.add_keyword_color(keyword, COLOR_KEYWORD)

	# Add custom method highlighting
	for method_name in custom_methods:
		highlighter.add_keyword_color(method_name, AC_SUGGESTIONS_COLOR)

	# Add built-in function colors
	for func_name in builtin_functions:
		highlighter.add_keyword_color(func_name, COLOR_FUNCTION)

	# Add string colors
	highlighter.add_color_region('"', '"', COLOR_STRING, false)
	highlighter.add_color_region("'", "'", COLOR_STRING, false)

	# Add comment colors
	highlighter.add_color_region("#", "", COLOR_COMMENT, true)

	return highlighter
```
