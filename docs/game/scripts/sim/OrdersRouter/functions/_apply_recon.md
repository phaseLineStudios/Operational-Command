# OrdersRouter::_apply_recon Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 144–154)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _apply_recon(unit: ScenarioUnit, order: Dictionary) -> bool
```

## Description

RECON: move with recon posture if supported.
[param unit] Subject unit.
[param order] Order dictionary.
[return] `true` if applied, `false` if missing destination.

## Source

```gdscript
func _apply_recon(unit: ScenarioUnit, order: Dictionary) -> bool:
	if combat_controller and combat_controller.has_method("set_posture"):
		combat_controller.set_posture(unit, "recon")
	var dest: Variant = _compute_destination(unit, order)
	if dest != null and movement_adapter and movement_adapter.plan_and_start(unit, dest):
		emit_signal("order_applied", order)
		return true
	emit_signal("order_failed", order, "recon_no_destination")
	return false
```
