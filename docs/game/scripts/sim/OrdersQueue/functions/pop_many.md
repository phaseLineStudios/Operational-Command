# OrdersQueue::pop_many Function Reference

*Defined at:* `scripts/sim/OrdersQueue.gd` (lines 47–54)</br>
*Belongs to:* [OrdersQueue](../../OrdersQueue.md)

**Signature**

```gdscript
func pop_many(max_count: int = 8) -> Array[Dictionary]
```

- **max_count**: Maximum number of orders to pop (default `8`).
- **Return Value**: Array[Dictionary] of popped orders (≤ `max_count`).

## Description

Pop up to `max_count` orders from the front of the queue.

## Source

```gdscript
func pop_many(max_count: int = 8) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	var n: int = min(max_count, _q.size())
	for i in n:
		out.append(_q.pop_front())
	return out
```
