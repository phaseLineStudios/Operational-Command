# OrdersQueue::enqueue_many Function Reference

*Defined at:* `scripts/sim/OrdersQueue.gd` (lines 36–43)</br>
*Belongs to:* [OrdersQueue](../../OrdersQueue.md)

**Signature**

```gdscript
func enqueue_many(orders: Array, units_by_callsign: Dictionary = {}) -> int
```

- **orders**: Array of order dictionaries.
- **units_by_callsign**: Callsign → unit_id map used to resolve targets.
- **Return Value**: Number of orders accepted.

## Description

Enqueue multiple orders.

## Source

```gdscript
func enqueue_many(orders: Array, units_by_callsign: Dictionary = {}) -> int:
	var ok := 0
	for o in orders:
		if enqueue(o, units_by_callsign):
			ok += 1
	return ok
```
