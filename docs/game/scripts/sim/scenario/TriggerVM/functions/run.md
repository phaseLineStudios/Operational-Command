# TriggerVM::run Function Reference

*Defined at:* `scripts/sim/scenario/TriggerVM.gd` (lines 48–60)</br>
*Belongs to:* [TriggerVM](../../TriggerVM.md)

**Signature**

```gdscript
func run(expr_src: String, ctx: Dictionary) -> void
```

- **expr_src**: Expression source.
- **ctx**: becomes constants accessible in the expression.

## Description

Run side-effect expressions (activation/deactivation). Ignores return values.

## Source

```gdscript
func run(expr_src: String, ctx: Dictionary) -> void:
	LogService.trace("Ran trigger expression", "TriggerVM.gd:49")
	var src := expr_src.strip_edges()
	if src == "":
		return
	for line in _split_lines(src):
		var compiled := _compile(line, ctx)
		if compiled == null:
			continue
		var inputs := _values_for(compiled.names, ctx)
		compiled.expr.execute(inputs, _api, false, false)
```
