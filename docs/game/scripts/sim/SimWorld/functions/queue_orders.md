# SimWorld::queue_orders Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 197–200)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func queue_orders(orders: Array) -> int
```

## Description

Enqueue structured orders parsed elsewhere.
[param orders] Array of order dictionaries.
[return] Number of orders accepted.

## Source

```gdscript
func queue_orders(orders: Array) -> int:
	return _orders.enqueue_many(orders, _playable_by_callsign)
```
