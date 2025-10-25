# SimWorld::queue_orders Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 327–330)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func queue_orders(orders: Array) -> int
```

- **orders**: Array of order dictionaries.
- **Return Value**: Number of orders accepted.

## Description

Enqueue structured orders parsed elsewhere.

## Source

```gdscript
func queue_orders(orders: Array) -> int:
	return _orders.enqueue_many(orders, _playable_by_callsign)
```
