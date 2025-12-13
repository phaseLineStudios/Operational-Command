# OrdersRouter::_apply_defend Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 163–173)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _apply_defend(unit: ScenarioUnit, order: Dictionary) -> bool
```

- **unit**: Subject unit.
- **order**: Order dictionary.
- **Return Value**: `true` if applied.

## Description

DEFEND: move to destination if present; otherwise hold.

## Source

```gdscript
func _apply_defend(unit: ScenarioUnit, order: Dictionary) -> bool:
	_apply_navigation_bias(unit, order)
	if combat_controller and combat_controller.has_method("set_posture"):
		combat_controller.set_posture(unit, "defend")
	var dest: Variant = _compute_destination(unit, order)
	if dest != null and movement_adapter and movement_adapter.plan_and_start(unit, dest):
		emit_signal("order_applied", order)
		return true
	return _apply_hold(unit, order)
```
