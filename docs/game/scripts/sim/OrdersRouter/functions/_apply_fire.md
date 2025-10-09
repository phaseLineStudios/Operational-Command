# OrdersRouter::_apply_fire Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 159–183)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _apply_fire(unit: ScenarioUnit, order: Dictionary) -> bool
```

## Description

FIRE: request fire mission if possible; else move to target unit.
[param unit] Subject unit.
[param order] Order dictionary.
[return] `true` if applied, otherwise `false`.

## Source

```gdscript
func _apply_fire(unit: ScenarioUnit, order: Dictionary) -> bool:
	var target: ScenarioUnit = _resolve_target(order)
	if target == null:
		if combat_controller and combat_controller.has_method("set_engagement_intent"):
			combat_controller.set_engagement_intent(unit, "fire")
			emit_signal("order_applied", order)
			return true
		emit_signal("order_failed", order, "fire_missing_target")
		return false
	if combat_controller:
		if combat_controller.has_method("request_fire_mission"):
			combat_controller.request_fire_mission(unit, target)
			emit_signal("order_applied", order)
			return true
		elif combat_controller.has_method("set_target"):
			combat_controller.set_target(unit, target)
			emit_signal("order_applied", order)
			return true
	if movement_adapter and movement_adapter.plan_and_start(unit, target.position_m):
		emit_signal("order_applied", order)
		return true
	emit_signal("order_failed", order, "fire_unhandled")
	return false
```
