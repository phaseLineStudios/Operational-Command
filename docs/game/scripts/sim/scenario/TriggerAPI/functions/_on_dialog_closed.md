# TriggerAPI::_on_dialog_closed Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 779–794)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func _on_dialog_closed() -> void
```

## Description

Handle dialog closed signal (internal).

## Source

```gdscript
func _on_dialog_closed() -> void:
	_dialog_blocking = false
	# Disconnect the signal to avoid memory leaks
	if _mission_dialog and _mission_dialog.is_connected("dialog_closed", _on_dialog_closed):
		_mission_dialog.dialog_closed.disconnect(_on_dialog_closed)

	# Execute pending expression if any
	if _dialog_pending_expr != "" and engine:
		var expr := _dialog_pending_expr
		var ctx := _dialog_pending_ctx
		_dialog_pending_expr = ""
		_dialog_pending_ctx = {}
		# Execute the remaining statements
		engine.execute_expression(expr, ctx)
```
