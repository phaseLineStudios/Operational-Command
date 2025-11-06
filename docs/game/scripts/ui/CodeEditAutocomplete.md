# CodeEditAutocomplete Class Reference

*File:* `scripts/ui/CodeEditAutocomplete.gd`
*Class name:* `CodeEditAutocomplete`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name CodeEditAutocomplete
extends RefCounted
```

## Brief

Autocomplete helper for CodeEdit nodes with custom method injection.

## Detailed Description

Provides autocomplete suggestions for CodeEdit nodes, including:
- Built-in GDScript keywords and operators
- Custom injected methods with descriptions
- Automatic signal connection and cleanup

Example:

```
var autocomplete := CodeEditAutocomplete.new()
autocomplete.add_method("time_s", "float", "Return mission time in seconds.")
autocomplete.add_method(
"radio", "void", "Send a radio/log message.",
["msg: String", "level: String = \"info\""]
)
autocomplete.attach(code_edit_node)
```

Add a custom method to autocomplete suggestions.
`name` Method name.
`return_type` Return type (e.g., "void", "int", "String").
`description` Method description shown in tooltip.
`params` Optional array of parameter strings
(e.g., ["msg: String", "level: String = \"info\""]).

## Public Member Functions

- [`func add_methods(methods: Dictionary) -> void`](CodeEditAutocomplete/functions/add_methods.md) — Add multiple custom methods at once.
- [`func clear_methods() -> void`](CodeEditAutocomplete/functions/clear_methods.md) — Clear all custom methods.
- [`func attach(code_edit: CodeEdit, enable_syntax_highlighting: bool = true) -> void`](CodeEditAutocomplete/functions/attach.md) — Attach autocomplete to a CodeEdit node.
- [`func detach() -> void`](CodeEditAutocomplete/functions/detach.md) — Detach from current CodeEdit node.
- [`func _on_code_completion_requested() -> void`](CodeEditAutocomplete/functions/_on_code_completion_requested.md) — Handle code completion request from CodeEdit.
- [`func _on_text_changed() -> void`](CodeEditAutocomplete/functions/_on_text_changed.md) — Handle text changes to auto-trigger completion.
- [`func _on_gui_input(event: InputEvent) -> void`](CodeEditAutocomplete/functions/_on_gui_input.md) — Handle keyboard input for manual completion trigger (Ctrl+Space).
- [`func _has_matching_suggestion(partial: String) -> bool`](CodeEditAutocomplete/functions/_has_matching_suggestion.md) — Check if partial word matches any suggestion.
- [`func _setup_syntax_highlighting() -> void`](CodeEditAutocomplete/functions/_setup_syntax_highlighting.md) — Setup syntax highlighting for GDScript.
- [`func _create_gdscript_highlighter() -> CodeHighlighter`](CodeEditAutocomplete/functions/_create_gdscript_highlighter.md) — Create a GDScript syntax highlighter.

## Public Attributes

- `Dictionary custom_methods` — Custom method definitions for autocomplete.
- `Array[String] base_keywords` — Base GDScript keywords and common functions.
- `Array[String] builtin_functions` — Common GDScript built-in functions.
- `PackedStringArray auto_trigger_chars` — Auto-trigger completion after typing these characters.
- `int min_word_length` — Minimum word length before auto-triggering completion.
- `CodeEdit _code_edit` — Reference to attached CodeEdit node.

## Public Constants

- `const AC_SUGGESTIONS_COLOR` — Color constants for syntax highlighting and completion
- `const COLOR_KEYWORD` — Syntax highlighting colors
- `const COLOR_CONTROL_FLOW`
- `const COLOR_NUMBER`
- `const COLOR_STRING`
- `const COLOR_COMMENT`
- `const COLOR_FUNCTION`
- `const COLOR_MEMBER`
- `const COLOR_SYMBOL`
- `const COLOR_BACKGROUND`
- `const COLOR_BACKGROUND_SELECTED`
- `const COLOR_LINE_NUMBER`
- `const COLOR_CARET`

## Member Function Documentation

### add_methods

```gdscript
func add_methods(methods: Dictionary) -> void
```

Add multiple custom methods at once.
`methods` Dictionary of method definitions.

### clear_methods

```gdscript
func clear_methods() -> void
```

Clear all custom methods.

### attach

```gdscript
func attach(code_edit: CodeEdit, enable_syntax_highlighting: bool = true) -> void
```

Attach autocomplete to a CodeEdit node.
`code_edit` CodeEdit node to attach to.
`enable_syntax_highlighting` If true, applies syntax highlighting (default: true).

### detach

```gdscript
func detach() -> void
```

Detach from current CodeEdit node.

### _on_code_completion_requested

```gdscript
func _on_code_completion_requested() -> void
```

Handle code completion request from CodeEdit.

### _on_text_changed

```gdscript
func _on_text_changed() -> void
```

Handle text changes to auto-trigger completion.

### _on_gui_input

```gdscript
func _on_gui_input(event: InputEvent) -> void
```

Handle keyboard input for manual completion trigger (Ctrl+Space).

### _has_matching_suggestion

```gdscript
func _has_matching_suggestion(partial: String) -> bool
```

Check if partial word matches any suggestion.

### _setup_syntax_highlighting

```gdscript
func _setup_syntax_highlighting() -> void
```

Setup syntax highlighting for GDScript.

### _create_gdscript_highlighter

```gdscript
func _create_gdscript_highlighter() -> CodeHighlighter
```

Create a GDScript syntax highlighter.

## Member Data Documentation

### custom_methods

```gdscript
var custom_methods: Dictionary
```

Custom method definitions for autocomplete.
Format: { "method_name": { "return_type": "...", "description": "...", "params": [...] } }

### base_keywords

```gdscript
var base_keywords: Array[String]
```

Base GDScript keywords and common functions.

### builtin_functions

```gdscript
var builtin_functions: Array[String]
```

Common GDScript built-in functions.

### auto_trigger_chars

```gdscript
var auto_trigger_chars: PackedStringArray
```

Auto-trigger completion after typing these characters.

### min_word_length

```gdscript
var min_word_length: int
```

Minimum word length before auto-triggering completion.

### _code_edit

```gdscript
var _code_edit: CodeEdit
```

Reference to attached CodeEdit node.

## Constant Documentation

### AC_SUGGESTIONS_COLOR

```gdscript
const AC_SUGGESTIONS_COLOR
```

Color constants for syntax highlighting and completion

### COLOR_KEYWORD

```gdscript
const COLOR_KEYWORD
```

Syntax highlighting colors

### COLOR_CONTROL_FLOW

```gdscript
const COLOR_CONTROL_FLOW
```

### COLOR_NUMBER

```gdscript
const COLOR_NUMBER
```

### COLOR_STRING

```gdscript
const COLOR_STRING
```

### COLOR_COMMENT

```gdscript
const COLOR_COMMENT
```

### COLOR_FUNCTION

```gdscript
const COLOR_FUNCTION
```

### COLOR_MEMBER

```gdscript
const COLOR_MEMBER
```

### COLOR_SYMBOL

```gdscript
const COLOR_SYMBOL
```

### COLOR_BACKGROUND

```gdscript
const COLOR_BACKGROUND
```

### COLOR_BACKGROUND_SELECTED

```gdscript
const COLOR_BACKGROUND_SELECTED
```

### COLOR_LINE_NUMBER

```gdscript
const COLOR_LINE_NUMBER
```

### COLOR_CARET

```gdscript
const COLOR_CARET
```
