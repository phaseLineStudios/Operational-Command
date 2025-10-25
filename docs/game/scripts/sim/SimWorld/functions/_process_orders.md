# SimWorld::_process_orders Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 184–189)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _process_orders() -> void
```

## Description

Pops ready orders and routes them via the OrdersRouter.

## Source

```gdscript
func _process_orders() -> void:
	var order_ready := _orders.pop_many(16)
	for o in order_ready:
		_router.apply(o)
```
