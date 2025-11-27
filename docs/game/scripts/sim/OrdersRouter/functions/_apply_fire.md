# OrdersRouter::_apply_fire Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 189–248)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _apply_fire(unit: ScenarioUnit, order: Dictionary) -> bool
```

- **unit**: Subject unit.
- **order**: Order dictionary.
- **Return Value**: `true` if applied, otherwise `false`.

## Description

FIRE: artillery indirect fire only (no direct fire or movement fallback).

## Source

```gdscript
func _apply_fire(unit: ScenarioUnit, order: Dictionary) -> bool:
	# FIRE order only works for artillery-capable units
	if not artillery_controller:
		LogService.error(
			"Artillery controller is NULL! Cannot process FIRE orders.", "OrdersRouter.gd"
		)
		emit_signal("order_failed", order, "fire_not_artillery")
		return false

	if not artillery_controller.is_artillery_unit(unit.id):
		emit_signal("order_failed", order, "fire_not_artillery")
		return false

	# Get destination from order (same as move orders)
	var dest: Variant = _compute_destination(unit, order)
	if dest == null or dest == Vector2.ZERO:
		emit_signal("order_failed", order, "fire_missing_target")
		return false

	# Get ammo type and rounds from order
	var ammo_type: String = order.get("ammo_type", "ap")
	var rounds: int = order.get("rounds", 1)

	# Map generic ammo type to unit-specific ammo type
	var available_types := artillery_controller.get_available_ammo_types(unit.id)
	var full_ammo_type := ""

	# Try to match ammo type to available types
	for available in available_types:
		if ammo_type == "ap" and available.ends_with("_AP"):
			full_ammo_type = available
			break
		elif ammo_type == "smoke" and available.ends_with("_SMOKE"):
			full_ammo_type = available
			break
		elif ammo_type == "illum" and available.ends_with("_ILLUM"):
			full_ammo_type = available
			break

	# If no matching ammo type found, try to use first available AP type
	if full_ammo_type == "":
		for available in available_types:
			if available.ends_with("_AP"):
				full_ammo_type = available
				break

	# If still no ammo type, fail the order
	if full_ammo_type == "":
		emit_signal("order_failed", order, "fire_no_ammo")
		return false

	# Request fire mission
	if artillery_controller.request_fire_mission(unit.id, dest, full_ammo_type, rounds):
		emit_signal("order_applied", order)
		return true
	else:
		emit_signal("order_failed", order, "fire_mission_rejected")
		return false
```
