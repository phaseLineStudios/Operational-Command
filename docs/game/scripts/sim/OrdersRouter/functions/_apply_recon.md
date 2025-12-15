# OrdersRouter::_apply_recon Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 181–192)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _apply_recon(unit: ScenarioUnit, order: Dictionary) -> bool
```

- **unit**: Subject unit.
- **order**: Order dictionary.
- **Return Value**: `true` if applied, `false` if missing destination.

## Description

RECON: move with recon posture if supported.

## Source

```gdscript
func _apply_recon(unit: ScenarioUnit, order: Dictionary) -> bool:
	_apply_navigation_bias(unit, order)
	if combat_controller and combat_controller.has_method("set_posture"):
		combat_controller.set_posture(unit, "recon")
	var dest: Variant = _compute_destination(unit, order)
	if dest != null and movement_adapter and movement_adapter.plan_and_start(unit, dest):
		emit_signal("order_applied", order)
		return true
	emit_signal("order_failed", order, "recon_no_destination")
	return false
```
