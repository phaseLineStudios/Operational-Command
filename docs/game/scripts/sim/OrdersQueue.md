# OrdersQueue Class Reference

*File:* `scripts/sim/OrdersQueue.gd`
*Class name:* `OrdersQueue`
*Inherits:* `RefCounted`
> **Experimental**

## Synopsis

```gdscript
class_name OrdersQueue
extends RefCounted
```

## Brief

FIFO queue for validated orders to be consumed by the sim.

## Detailed Description

Holds raw/normalized order dictionaries, provides light validation,
and exposes batch enqueue/dequeue helpers.

## Public Member Functions

- [`func enqueue(order: Dictionary, units_by_callsign: Dictionary = {}) -> bool`](OrdersQueue/functions/enqueue.md) — Enqueue a single order.
- [`func enqueue_many(orders: Array, units_by_callsign: Dictionary = {}) -> int`](OrdersQueue/functions/enqueue_many.md) — Enqueue multiple orders.
- [`func pop_many(max_count: int = 8) -> Array[Dictionary]`](OrdersQueue/functions/pop_many.md) — Pop up to `max_count` orders from the front of the queue.
- [`func size() -> int`](OrdersQueue/functions/size.md) — Current queue size.
- [`func clear() -> void`](OrdersQueue/functions/clear.md) — Clear all pending orders.
- [`func validate(order: Dictionary, units_by_callsign: Dictionary = {}) -> Dictionary`](OrdersQueue/functions/validate.md) — Validate and lightly normalize an order.

## Public Attributes

- `Array[Dictionary] _q`

## Signals

- `signal order_enqueued(order: Dictionary)` — Emitted when an order is accepted into the queue.
- `signal order_rejected(order: Dictionary, reason: String)` — Emitted when validation rejects an order.

## Member Function Documentation

### enqueue

```gdscript
func enqueue(order: Dictionary, units_by_callsign: Dictionary = {}) -> bool
```

Enqueue a single order.
`order` Order dictionary (may include "callsign" or "unit_id").
`units_by_callsign` Map callsign:String -> unit_id:String used to resolve targets.
[return] true if accepted, false if rejected.

### enqueue_many

```gdscript
func enqueue_many(orders: Array, units_by_callsign: Dictionary = {}) -> int
```

Enqueue multiple orders.
`orders` Array of order dictionaries.
`units_by_callsign` Callsign → unit_id map used to resolve targets.
[return] Number of orders accepted.

### pop_many

```gdscript
func pop_many(max_count: int = 8) -> Array[Dictionary]
```

Pop up to `max_count` orders from the front of the queue.
`max_count` Maximum number of orders to pop (default `8`).
[return] Array[Dictionary] of popped orders (≤ `max_count`).

### size

```gdscript
func size() -> int
```

Current queue size.
[return] Number of pending orders.

### clear

```gdscript
func clear() -> void
```

Clear all pending orders.

### validate

```gdscript
func validate(order: Dictionary, units_by_callsign: Dictionary = {}) -> Dictionary
```

Validate and lightly normalize an order.
Ensures the structure is a Dictionary, resolves `"callsign"` to `"unit_id"`
when possible, and checks minimal fields per type.
`order` Order dictionary to validate.
`units_by_callsign` Callsign → unit_id map used to resolve targets.
[return] Dictionary `{ "valid": bool, "reason": String, "order": Dictionary }`.

## Member Data Documentation

### _q

```gdscript
var _q: Array[Dictionary]
```

## Signal Documentation

### order_enqueued

```gdscript
signal order_enqueued(order: Dictionary)
```

Emitted when an order is accepted into the queue.

### order_rejected

```gdscript
signal order_rejected(order: Dictionary, reason: String)
```

Emitted when validation rejects an order.
