# OrdersQueue::size Function Reference

*Defined at:* `scripts/sim/OrdersQueue.gd` (lines 57–60)</br>
*Belongs to:* [OrdersQueue](../../OrdersQueue.md)

**Signature**

```gdscript
func size() -> int
```

- **Return Value**: Number of pending orders.

## Description

Current queue size.

## Source

```gdscript
func size() -> int:
	return _q.size()
```
