# OrdersRouter::_apply_move Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 102–130)</br>
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
	_apply_navigation_bias(unit, order)
	var dest: Variant = _compute_destination(unit, order)
	if dest == null:
		emit_signal("order_failed", order, "move_missing_destination")
		return false
	if dest == Vector2.ZERO:
		emit_signal("order_failed", order, "move_destination_zero")
		return false

	# Check if this is a direct move (straight line, no pathfinding)
	var is_direct: bool = order.get("direct", false)
	var success: bool = false

	if movement_adapter:
		if is_direct:
			success = movement_adapter.plan_and_start_direct(unit, dest)
		else:
			success = movement_adapter.plan_and_start(unit, dest)
		if order.has("navigation_bias") and order.navigation_bias == StringName("roads"):
			LogService.info("Order applied with road bias for %s" % unit.id, "OrdersRouter.gd")

	if success:
		emit_signal("order_applied", order)
		return true
	emit_signal("order_failed", order, "move_plan_failed")
	return false
```
