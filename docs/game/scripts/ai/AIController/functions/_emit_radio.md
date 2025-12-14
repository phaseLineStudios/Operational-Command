# AIController::_emit_radio Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 599–607)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func _emit_radio(level: String, msg: String) -> void
```

## Source

```gdscript
func _emit_radio(level: String, msg: String) -> void:
	# Emit via OrdersRouter if it supports radio_message, else log only.
	if _orders_router and _orders_router.has_signal("radio_message"):
		_orders_router.emit_signal("radio_message", level, msg)
	else:
		if level == "warn":
			LogService.warning(msg, "AIController.gd")
		else:
			LogService.info(msg, "AIController.gd")
```
