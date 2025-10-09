# OrdersRouter::_apply_attack Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 115–125)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _apply_attack(unit: ScenarioUnit, order: Dictionary) -> bool
```

## Description

ATTACK: prefer target_callsign; otherwise use movement fallback.
[param unit] Subject unit.
[param order] Order dictionary.
[return] Always `true` (intent set even if no move).

## Source

```gdscript
func _apply_attack(unit: ScenarioUnit, order: Dictionary) -> bool:
	if combat_controller and combat_controller.has_method("set_engagement_intent"):
		combat_controller.set_engagement_intent(unit, "attack")
	var dest: Variant = _compute_destination(unit, order, true)
	if dest != null and movement_adapter and movement_adapter.plan_and_start(unit, dest):
		emit_signal("order_applied", order)
		return true
	emit_signal("order_applied", order)
	return true
```
