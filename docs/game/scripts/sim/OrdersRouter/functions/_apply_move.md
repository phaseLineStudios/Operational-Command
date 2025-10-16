# OrdersRouter::_apply_move Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 87–101)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _apply_move(unit: ScenarioUnit, order: Dictionary) -> bool
```

- **unit**: Subject unit.
- **order**: Order dictionary.
- **Return Value**: `true` if movement was planned/started, else `false`.

## Description

MOVE: compute destination from grid, target_callsign (unit or label), or direction+quantity.

## Source

```gdscript
func _apply_move(unit: ScenarioUnit, order: Dictionary) -> bool:
	var dest: Variant = _compute_destination(unit, order)
	if dest == null:
		emit_signal("order_failed", order, "move_missing_destination")
		return false
	if dest == Vector2.ZERO:
		emit_signal("order_failed", order, "move_destination_zero")
		return false
	if movement_adapter and movement_adapter.plan_and_start(unit, dest):
		emit_signal("order_applied", order)
		return true
	emit_signal("order_failed", order, "move_plan_failed")
	return false
```
