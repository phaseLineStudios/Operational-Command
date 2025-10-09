# SimWorld::_on_order_applied Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 326–331)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _on_order_applied(order: Dictionary) -> void
```

## Description

Router callback: order applied.
[param order] Order dictionary.

## Source

```gdscript
func _on_order_applied(order: Dictionary) -> void:
	emit_signal("radio_message", "info", "Order applied: %s" % order.get("type", "?"))
	var hr_order: String = OrdersParser.OrderType.keys()[int(order.get("type", -1))]
	LogService.info("radio_message: %s" % {"Order applied": hr_order}, "SimWorld.gd:293")
```
