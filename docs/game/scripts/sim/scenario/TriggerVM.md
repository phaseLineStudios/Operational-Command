# TriggerVM Class Reference

*File:* `scripts/sim/scenario/TriggerVM.gd`
*Class name:* `TriggerVM`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name TriggerVM
extends RefCounted
```

## Brief

Execute a block of lines starting from a given index.

## Detailed Description

Returns the index after the block ends.
`lines` Array of {indent: int, code: String}.
`start_idx` Starting index.
`ctx` Context dictionary.
`local_vars` Local variables dictionary.
`debug_info` Optional debug info.
[return] Index after the block ends.

Execute an if/elif/else block.
Returns the index after the entire if block ends.

Evaluate a condition expression.

Execute a var declaration (var name = expression).

Execute an assignment (variable = expression).

Execute a single expression (function call, etc.).

Evaluate an expression and return the result.

Check if sleep or dialog blocking was requested, and handle remaining code.
Returns true if execution should stop.

## Public Member Functions

- [`func set_api(api: TriggerAPI) -> void`](TriggerVM/functions/set_api.md) — Provide the helper API used by scripts.
- [`func eval_condition(expr_src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> bool`](TriggerVM/functions/eval_condition.md) — Evaluate a condition expression.
- [`func run(expr_src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> void`](TriggerVM/functions/run.md) — Run side-effect expressions (activation/deactivation).
- [`func _compile(src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> Variant`](TriggerVM/functions/_compile.md) — Compile a given expression.
- [`func _values_for(names: PackedStringArray, ctx: Dictionary) -> Array`](TriggerVM/functions/_values_for.md) — Creates inputs from context.
- [`func _sorted_keys(ctx: Dictionary) -> PackedStringArray`](TriggerVM/functions/_sorted_keys.md) — Sorts context keys.
- [`func _split_lines(src: String) -> PackedStringArray`](TriggerVM/functions/_split_lines.md) — Split source by lines, respecting multi-line expressions.
- [`func _line_needs_continuation(line: String) -> bool`](TriggerVM/functions/_line_needs_continuation.md) — Check if a line ends with a token that requires continuation on the next line.
- [`func _execute_script(src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> void`](TriggerVM/functions/_execute_script.md) — Execute a script with control flow support (if/elif/else, var, assignments).
- [`func _skip_branch(lines: Array, start_idx: int, base_indent: int) -> int`](TriggerVM/functions/_skip_branch.md) — Skip a branch (the indented block after if/elif/else).
- [`func _skip_remaining_branches(lines: Array, start_idx: int, base_indent: int) -> int`](TriggerVM/functions/_skip_remaining_branches.md) — Skip remaining elif/else branches after one has been executed.
- [`func _reconstruct_remaining(lines: Array, start_idx: int) -> String`](TriggerVM/functions/_reconstruct_remaining.md) — Reconstruct remaining source code from line array.
- [`func _parse_indented_lines(src: String) -> Array`](TriggerVM/functions/_parse_indented_lines.md) — Parse source into lines with indentation info.
- [`func _strip_comments(src: String) -> String`](TriggerVM/functions/_strip_comments.md) — Strip comments from source code whdwile preserving strings.

## Public Attributes

- `TriggerAPI _api` — Tiny sandbox runner around Godot's Expression.
- `Dictionary _cache`
- `int base_indent`
- `Dictionary line_info`
- `int indent`
- `String code`
- `Variant compiled`
- `Variant result`
- `Variant value`

## Member Function Documentation

### set_api

```gdscript
func set_api(api: TriggerAPI) -> void
```

Provide the helper API used by scripts.

### eval_condition

```gdscript
func eval_condition(expr_src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> bool
```

Evaluate a condition expression.
`expr_src` Expression source.
`ctx` becomes constants accessible in the expression.
`debug_info` Optional debug info for error messages (trigger_id, expr_type).
[return] empty/"true" -> true.

### run

```gdscript
func run(expr_src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> void
```

Run side-effect expressions (activation/deactivation). Ignores return values.
Handles blocking sleep and dialog blocking:
- If sleep is called, remaining statements are scheduled for later execution
- If dialog blocking is requested, remaining statements execute when dialog closes
`expr_src` Expression source.
`ctx` becomes constants accessible in the expression.
`debug_info` Optional debug info for error messages (trigger_id, expr_type).

### _compile

```gdscript
func _compile(src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> Variant
```

Compile a given expression.
`src` Source to compile (should already have comments stripped).
`ctx` Context dictionary.
`debug_info` Optional debug info for error messages.
[return] Compiled expression, or null on error.

### _values_for

```gdscript
func _values_for(names: PackedStringArray, ctx: Dictionary) -> Array
```

Creates inputs from context.
`names` Compiled names.
`ctx` becomes constants accessible in the expression.
[return] Array of inputs.

### _sorted_keys

```gdscript
func _sorted_keys(ctx: Dictionary) -> PackedStringArray
```

Sorts context keys.
`ctx` becomes constants accessible in the expression.
[return] Array of sorted keys.

### _split_lines

```gdscript
func _split_lines(src: String) -> PackedStringArray
```

Split source by lines, respecting multi-line expressions.
Handles parentheses, brackets, and braces to keep multi-line calls together.
`src` Source string.
[return] PackedStringArray of code lines.

### _line_needs_continuation

```gdscript
func _line_needs_continuation(line: String) -> bool
```

Check if a line ends with a token that requires continuation on the next line.
`line` Line to check.
[return] True if the line needs continuation.

### _execute_script

```gdscript
func _execute_script(src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> void
```

Execute a script with control flow support (if/elif/else, var, assignments).
`src` Source code (comments already stripped).
`ctx` Context dictionary.
`debug_info` Optional debug info for error messages.

### _skip_branch

```gdscript
func _skip_branch(lines: Array, start_idx: int, base_indent: int) -> int
```

Skip a branch (the indented block after if/elif/else).

### _skip_remaining_branches

```gdscript
func _skip_remaining_branches(lines: Array, start_idx: int, base_indent: int) -> int
```

Skip remaining elif/else branches after one has been executed.

### _reconstruct_remaining

```gdscript
func _reconstruct_remaining(lines: Array, start_idx: int) -> String
```

Reconstruct remaining source code from line array.

### _parse_indented_lines

```gdscript
func _parse_indented_lines(src: String) -> Array
```

Parse source into lines with indentation info.
Returns Array of {indent: int, code: String}.

### _strip_comments

```gdscript
func _strip_comments(src: String) -> String
```

Strip comments from source code whdwile preserving strings.
`src` Source code.
[return] Source code with comments removed.

## Member Data Documentation

### _api

```gdscript
var _api: TriggerAPI
```

Tiny sandbox runner around Godot's Expression.
Parses and runs simple expressions with a whitelisted helper API.

### _cache

```gdscript
var _cache: Dictionary
```

### base_indent

```gdscript
var base_indent: int
```

### line_info

```gdscript
var line_info: Dictionary
```

### indent

```gdscript
var indent: int
```

### code

```gdscript
var code: String
```

### compiled

```gdscript
var compiled: Variant
```

### result

```gdscript
var result: Variant
```

### value

```gdscript
var value: Variant
```
