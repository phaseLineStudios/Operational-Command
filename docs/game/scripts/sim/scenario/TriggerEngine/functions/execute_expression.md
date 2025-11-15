# TriggerEngine::execute_expression Function Reference

*Defined at:* `scripts/sim/scenario/TriggerEngine.gd` (lines 350–354)</br>
*Belongs to:* [TriggerEngine](../../TriggerEngine.md)

**Signature**

```gdscript
func execute_expression(expr: String, ctx: Dictionary) -> void
```

- **expr**: Expression to execute.
- **ctx**: Context dictionary for the expression.

## Description

Execute an expression immediately (used by dialog blocking).

## Source

```gdscript
func execute_expression(expr: String, ctx: Dictionary) -> void:
	if _vm:
		_vm.run(expr, ctx)
```
