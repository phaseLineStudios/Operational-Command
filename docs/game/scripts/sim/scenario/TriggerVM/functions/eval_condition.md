# TriggerVM::eval_condition Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 20–45)</br>
*Belongs to:* [TriggerVM](../../TriggerVM.md)

**Signature**

```gdscript
func eval_condition(expr_src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> bool
```

- **expr_src**: Expression source.
- **ctx**: becomes constants accessible in the expression.
- **debug_info**: Optional debug info for error messages (trigger_id, expr_type).
- **Return Value**: empty/"true" -> true.

## Description

Evaluate a condition expression.

## Source

```gdscript
func eval_condition(expr_src: String, ctx: Dictionary, debug_info: Dictionary = {}) -> bool:
	var src := expr_src.strip_edges()
	if src == "" or src == "true":
		return true

	var lines := _split_lines(src)
	var last: Variant = true
	for line in lines:
		var compiled: Variant = _compile(line, ctx, debug_info)
		if compiled == null:
			return false

		var inputs := _values_for(compiled.names, ctx)
		last = compiled.expr.execute(inputs, _api, false, false)
		if compiled.expr.has_execute_failed():
			return false

		if typeof(last) == TYPE_BOOL and last == false:
			return false

		if typeof(last) == TYPE_NIL:
			return false

	return bool(last)
```
