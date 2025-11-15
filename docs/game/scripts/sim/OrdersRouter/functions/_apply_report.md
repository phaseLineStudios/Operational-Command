# OrdersRouter::_apply_report Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 253–257)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _apply_report(_unit: ScenarioUnit, order: Dictionary) -> bool
```

- **_unit**: Subject unit (unused).
- **order**: Order dictionary.
- **Return Value**: Always `true`.

## Description

REPORT: informational pass-through.

## Source

```gdscript
func _apply_report(_unit: ScenarioUnit, order: Dictionary) -> bool:
	emit_signal("order_applied", order)
	return true
```
