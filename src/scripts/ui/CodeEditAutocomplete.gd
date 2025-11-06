class_name CodeEditAutocomplete
extends RefCounted
## Autocomplete helper for CodeEdit nodes with custom method injection.
##
## Provides autocomplete suggestions for CodeEdit nodes, including:
## - Built-in GDScript keywords and operators
## - Custom injected methods with descriptions
## - Automatic signal connection and cleanup
##
## Example:
## [codeblock]
## var autocomplete := CodeEditAutocomplete.new()
## autocomplete.add_method("time_s", "float", "Return mission time in seconds.")
## autocomplete.add_method(
##     "radio", "void", "Send a radio/log message.",
##     ["msg: String", "level: String = \"info\""]
## )
## autocomplete.attach(code_edit_node)
## [/codeblock]

## Color constants for syntax highlighting and completion
const AC_SUGGESTIONS_COLOR = Color(0.737, 0.878, 1.0, 1.0)

## Syntax highlighting colors
const COLOR_KEYWORD = Color(1.0, 0.44, 0.52, 1.0)  # Pink/Red for keywords
const COLOR_CONTROL_FLOW = Color(1.0, 0.55, 0.8, 1.0)  # Light pink for control flow
const COLOR_NUMBER = Color(0.67, 0.87, 0.93, 1.0)  # Light blue for numbers
const COLOR_STRING = Color(1.0, 0.93, 0.63, 1.0)  # Yellow for strings
const COLOR_COMMENT = Color(0.5, 0.5, 0.5, 1.0)  # Gray for comments
const COLOR_FUNCTION = Color(0.34, 0.73, 1.0, 1.0)  # Blue for functions
const COLOR_MEMBER = Color(0.73, 0.88, 1.0, 1.0)  # Light blue for members
const COLOR_SYMBOL = Color(0.67, 0.79, 0.87, 1.0)  # Gray-blue for symbols
const COLOR_BACKGROUND = Color(0.12, 0.12, 0.16, 1.0)  # Dark background
const COLOR_BACKGROUND_SELECTED = Color(0.26, 0.32, 0.4, 1.0)  # Selected line
const COLOR_LINE_NUMBER = Color(0.67, 0.67, 0.67, 0.4)  # Line numbers
const COLOR_CARET = Color(1.0, 1.0, 1.0, 1.0)  # White caret

## Custom method definitions for autocomplete.
## Format: { "method_name": { "return_type": "...", "description": "...", "params": [...] } }
var custom_methods: Dictionary = {}

## Base GDScript keywords and common functions.
var base_keywords: Array[String] = [
	"if",
	"else",
	"elif",
	"for",
	"while",
	"match",
	"break",
	"continue",
	"pass",
	"return",
	"func",
	"var",
	"const",
	"class",
	"extends",
	"signal",
	"enum",
	"true",
	"false",
	"null",
	"and",
	"or",
	"not",
	"in",
	"is",
	"await",
	"super",
	"self",
]

## Common GDScript built-in functions.
var builtin_functions: Array[String] = [
	"print",
	"push_error",
	"push_warning",
	"abs",
	"ceil",
	"floor",
	"round",
	"sqrt",
	"pow",
	"min",
	"max",
	"clamp",
	"lerp",
	"sign",
	"sin",
	"cos",
	"tan",
	"asin",
	"acos",
	"atan",
	"atan2",
	"str",
	"int",
	"float",
	"bool",
	"len",
	"range",
]

## Auto-trigger completion after typing these characters.
var auto_trigger_chars: PackedStringArray = [".", "(", " "]

## Minimum word length before auto-triggering completion.
var min_word_length: int = 1

## Reference to attached CodeEdit node.
var _code_edit: CodeEdit = null


## Add a custom method to autocomplete suggestions.
## [param name] Method name.
## [param return_type] Return type (e.g., "void", "int", "String").
## [param description] Method description shown in tooltip.
## [param params] Optional array of parameter strings
## (e.g., ["msg: String", "level: String = \"info\""]).
func add_method(
	name: String, return_type: String, description: String, params: Array[String] = []
) -> void:
	custom_methods[name] = {
		"return_type": return_type,
		"description": description,
		"params": params,
	}


## Add multiple custom methods at once.
## [param methods] Dictionary of method definitions.
func add_methods(methods: Dictionary) -> void:
	for method_name in methods:
		var method_data: Dictionary = methods[method_name]
		var params_array: Array[String] = []
		var raw_params: Array = method_data.get("params", [])
		for param in raw_params:
			params_array.append(str(param))
		add_method(
			method_name,
			method_data.get("return_type", "void"),
			method_data.get("description", ""),
			params_array
		)


## Clear all custom methods.
func clear_methods() -> void:
	custom_methods.clear()


## Attach autocomplete to a CodeEdit node.
## [param code_edit] CodeEdit node to attach to.
## [param enable_syntax_highlighting] If true, applies syntax highlighting (default: true).
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


## Detach from current CodeEdit node.
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


## Handle code completion request from CodeEdit.
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


## Handle text changes to auto-trigger completion.
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


## Handle keyboard input for manual completion trigger (Ctrl+Space).
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


## Check if partial word matches any suggestion.
func _has_matching_suggestion(partial: String) -> bool:
	if partial.is_empty():
		return false

	partial = partial.to_lower()

	# Check custom methods
	for method_name in custom_methods:
		if method_name.to_lower().begins_with(partial):
			return true

	# Check keywords
	for keyword in base_keywords:
		if keyword.to_lower().begins_with(partial):
			return true

	# Check built-in functions
	for func_name in builtin_functions:
		if func_name.to_lower().begins_with(partial):
			return true

	return false


## Setup syntax highlighting for GDScript.
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


## Create a GDScript syntax highlighter.
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
