# SimWorld::_on_order_applied Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 759–769)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _on_order_applied(order: Dictionary) -> void
```

- **order**: Order dictionary.

## Description

Router callback: order applied.

## Source

```gdscript
func _on_order_applied(order: Dictionary) -> void:
	var order_type: int = int(order.get("type", -1))
	# Skip generic acknowledgement for orders that have specific feedback
	# (ENGINEER, FIRE have their own controller signals)
	if order_type == OrdersParser.OrderType.ENGINEER or order_type == OrdersParser.OrderType.FIRE:
		return
	emit_signal("radio_message", "debug", "Order applied: %s" % order.get("type", "?"))
	var hr_order: String = OrdersParser.OrderType.keys()[order_type]
	LogService.info("radio_message: %s" % {"Order applied": hr_order}, "SimWorld.gd:293")
```
