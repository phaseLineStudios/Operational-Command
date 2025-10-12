# OrdersQueue::enqueue Function Reference

*Defined at:* `scripts/sim/OrdersQueue.gd` (lines 21–31)</br>
*Belongs to:* [OrdersQueue](../../OrdersQueue.md)

**Signature**

```gdscript
func enqueue(order: Dictionary, units_by_callsign: Dictionary = {}) -> bool
```

- **order**: Order dictionary (may include "callsign" or "unit_id").
- **units_by_callsign**: Map callsign:String -> unit_id:String used to resolve targets.
- **Return Value**: true if accepted, false if rejected.

## Description

Enqueue a single order.

## Source

```gdscript
func enqueue(order: Dictionary, units_by_callsign: Dictionary = {}) -> bool:
	var v := validate(order, units_by_callsign)
	if not v.valid:
		emit_signal("order_rejected", order, v.reason)
		return false

	_q.append(v.order)
	emit_signal("order_enqueued", v.order)
	return true
```
