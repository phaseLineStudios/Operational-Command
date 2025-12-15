# OrdersRouter::_apply_navigation_bias Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 569–575)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _apply_navigation_bias(unit: ScenarioUnit, order: Dictionary) -> void
```

## Description

Apply navigation bias metadata to movement adapter if present.

## Source

```gdscript
func _apply_navigation_bias(unit: ScenarioUnit, order: Dictionary) -> void:
	if unit == null or order == null:
		return
	if not order.has("navigation_bias"):
		return
	if movement_adapter and movement_adapter.has_method("set_navigation_bias"):
		movement_adapter.set_navigation_bias(unit, order.navigation_bias)
```
