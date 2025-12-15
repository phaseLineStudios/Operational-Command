# TriggerAPI::_set_dialog_pending Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 600–604)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func _set_dialog_pending(expr: String, ctx: Dictionary) -> void
```

- **expr**: Expression to execute.
- **ctx**: Context dictionary.

## Description

Set pending expression to execute when dialog closes (internal use by TriggerVM).

## Source

```gdscript
func _set_dialog_pending(expr: String, ctx: Dictionary) -> void:
	_dialog_pending_expr = expr
	_dialog_pending_ctx = ctx
```
