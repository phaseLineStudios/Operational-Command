# TriggerVM::eval_condition Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 19–44)</br>
*Belongs to:* [TriggerVM](../../TriggerVM.md)

**Signature**

```gdscript
func eval_condition(expr_src: String, ctx: Dictionary) -> bool
```

- **expr_src**: Expression source.
- **ctx**: becomes constants accessible in the expression.
- **Return Value**: empty/"true" -> true.

## Description

Evaluate a condition expression.

## Source

```gdscript
func eval_condition(expr_src: String, ctx: Dictionary) -> bool:
	var src := expr_src.strip_edges()
	if src == "" or src == "true":
		return true

	var lines := _split_lines(src)
	var last: Variant = true
	for line in lines:
		var compiled := _compile(line, ctx)
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
