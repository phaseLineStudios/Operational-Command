# OrdersRouter::_apply_hold Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 135–143)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _apply_hold(unit: ScenarioUnit, order: Dictionary) -> bool
```

- **unit**: Subject unit.
- **order**: Order dictionary.
- **Return Value**: Always `true`.

## Description

HOLD/CANCEL: stop movement and clear combat intent (if supported).

## Source

```gdscript
func _apply_hold(unit: ScenarioUnit, order: Dictionary) -> bool:
	if movement_adapter:
		movement_adapter.cancel_move(unit)
	if combat_controller and combat_controller.has_method("clear_intent"):
		combat_controller.clear_intent(unit)
	emit_signal("order_applied", order)
	return true
```
