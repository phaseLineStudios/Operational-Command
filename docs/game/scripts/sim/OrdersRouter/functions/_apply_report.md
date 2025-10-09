# OrdersRouter::_apply_report Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 188–192)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _apply_report(_unit: ScenarioUnit, order: Dictionary) -> bool
```

## Description

REPORT: informational pass-through.
[param _unit] Subject unit (unused).
[param order] Order dictionary.
[return] Always `true`.

## Source

```gdscript
func _apply_report(_unit: ScenarioUnit, order: Dictionary) -> bool:
	emit_signal("order_applied", order)
	return true
```
