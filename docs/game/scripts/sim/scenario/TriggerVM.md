# TriggerVM Class Reference

*File:* `scripts/sim/scenario/TriggerVM.gd`
*Class name:* `TriggerVM`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name TriggerVM
extends RefCounted
```

## Public Member Functions

- [`func set_api(api: TriggerAPI) -> void`](TriggerVM/functions/set_api.md) — Provide the helper API used by scripts.
- [`func eval_condition(expr_src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> bool`](TriggerVM/functions/eval_condition.md) — Evaluate a condition expression.
- [`func run(expr_src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> void`](TriggerVM/functions/run.md) — Run side-effect expressions (activation/deactivation).
- [`func _compile(src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> Variant`](TriggerVM/functions/_compile.md) — Compile a given expression.
- [`func _values_for(names: PackedStringArray, ctx: Dictionary) -> Array`](TriggerVM/functions/_values_for.md) — Creates inputs from context.
- [`func _sorted_keys(ctx: Dictionary) -> PackedStringArray`](TriggerVM/functions/_sorted_keys.md) — Sorts context keys.
- [`func _split_lines(src: String) -> PackedStringArray`](TriggerVM/functions/_split_lines.md) — Split source by lines, respecting multi-line expressions.
- [`func _line_needs_continuation(line: String) -> bool`](TriggerVM/functions/_line_needs_continuation.md) — Check if a line ends with a token that requires continuation on the next line.

## Public Attributes

- `TriggerAPI _api` — Tiny sandbox runner around Godot's Expression.
- `Dictionary _cache`

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
`src` Source to compile.
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
