# OrdersRouter::_apply_engineer Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 262–298)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _apply_engineer(unit: ScenarioUnit, order: Dictionary) -> bool
```

- **unit**: Subject unit.
- **order**: Order dictionary.
- **Return Value**: `true` if applied, otherwise `false`.

## Description

ENGINEER: engineer task orders (mines, demo, bridges).

## Source

```gdscript
func _apply_engineer(unit: ScenarioUnit, order: Dictionary) -> bool:
	# ENGINEER order only works for engineer-capable units
	if not engineer_controller:
		LogService.error(
			"Engineer controller is NULL! Cannot process ENGINEER orders.", "OrdersRouter.gd"
		)
		emit_signal("order_failed", order, "engineer_controller_missing")
		return false

	if not engineer_controller.is_engineer_unit(unit.id):
		emit_signal("order_failed", order, "engineer_not_capable")
		return false

	# Get destination from order (same as move orders)
	var dest: Variant = _compute_destination(unit, order)
	if dest == null or dest == Vector2.ZERO:
		emit_signal("order_failed", order, "engineer_missing_target")
		return false

	# Get engineer task type from order
	var task_type: String = order.get("engineer_task", "mine")

	# Request engineer task (this queues the task, which will start when unit arrives)
	if not engineer_controller.request_task(unit.id, task_type, dest):
		emit_signal("order_failed", order, "engineer_task_rejected")
		return false

	# Move unit to destination (task will start when unit arrives)
	if movement_adapter and movement_adapter.plan_and_start(unit, dest):
		emit_signal("order_applied", order)
		return true

	# Movement failed, but task was queued (unit may already be at destination)
	emit_signal("order_applied", order)
	return true
```
