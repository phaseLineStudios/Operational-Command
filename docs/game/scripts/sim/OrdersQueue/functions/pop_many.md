# OrdersQueue::pop_many Function Reference

*Defined at:* `scripts/sim/OrdersQueue.gd` (lines 47–54)</br>
*Belongs to:* [OrdersQueue](../../OrdersQueue.md)

**Signature**

```gdscript
func pop_many(max_count: int = 8) -> Array[Dictionary]
```

## Description

Pop up to `max_count` orders from the front of the queue.
[param max_count] Maximum number of orders to pop (default `8`).
[return] Array[Dictionary] of popped orders (≤ `max_count`).

## Source

```gdscript
func pop_many(max_count: int = 8) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	var n: int = min(max_count, _q.size())
	for i in n:
		out.append(_q.pop_front())
	return out
```
