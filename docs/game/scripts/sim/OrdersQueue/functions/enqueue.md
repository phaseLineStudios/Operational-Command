# OrdersQueue::enqueue Function Reference

*Defined at:* `scripts/sim/OrdersQueue.gd` (lines 21–31)</br>
*Belongs to:* [OrdersQueue](../../OrdersQueue.md)

**Signature**

```gdscript
func enqueue(order: Dictionary, units_by_callsign: Dictionary = {}) -> bool
```

## Description

Enqueue a single order.
[param order] Order dictionary (may include "callsign" or "unit_id").
[param units_by_callsign] Map callsign:String -> unit_id:String used to resolve targets.
[return] true if accepted, false if rejected.

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
