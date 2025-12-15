# OrdersRouter::_apply_retreat Function Reference

*Defined at:* `scripts/sim/OrdersRouter.gd` (lines 313–384)</br>
*Belongs to:* [OrdersRouter](../../OrdersRouter.md)

**Signature**

```gdscript
func _apply_retreat(unit: ScenarioUnit, order: Dictionary) -> bool
```

- **unit**: Subject unit.
- **order**: Order dictionary.
- **Return Value**: `true` if retreat was initiated, otherwise `false`.

## Description

RETREAT: Unit falls back away from enemies silently (no player notifications).
Calculates weighted retreat direction based on all nearby threats.
If no threats are visible, retreats toward rear (south/southwest by default).

## Source

```gdscript
func _apply_retreat(unit: ScenarioUnit, order: Dictionary) -> bool:
	if not movement_adapter:
		emit_signal("order_failed", order, "movement_adapter_missing")
		return false

	# Find all enemy units within extended threat range
	var threat_range_m := 5000.0  # Consider enemies within 5km (extended for better detection)
	var retreat_distance_m := 500.0  # Retreat at least 500m

	var threats: Array[ScenarioUnit] = []
	var enemy_affiliation := (
		ScenarioUnit.Affiliation.ENEMY
		if unit.affiliation == ScenarioUnit.Affiliation.FRIEND
		else ScenarioUnit.Affiliation.FRIEND
	)

	for uid in _units_by_id.keys():
		var other: ScenarioUnit = _units_by_id[uid]
		if other == null or other == unit or other.is_dead():
			continue
		if other.affiliation != enemy_affiliation:
			continue

		var dist := unit.position_m.distance_to(other.position_m)
		if dist <= threat_range_m:
			threats.append(other)

	var retreat_vec := Vector2.ZERO

	if threats.is_empty():
		# No visible threats - use default retreat direction (toward rear/south)
		# This allows retreat orders even when enemies aren't in LOS
		retreat_vec = Vector2(0, 1)  # South (assuming north is forward)
		LogService.info(
			"%s retreating to default direction (no threats detected)" % unit.callsign,
			"OrdersRouter"
		)
	else:
		# Calculate weighted retreat vector away from all threats
		for threat in threats:
			var to_threat := threat.position_m - unit.position_m
			var dist := to_threat.length()
			if dist < 1.0:
				dist = 1.0
			# Weight by inverse distance (closer threats are more important)
			var weight := 1.0 / (dist * dist)
			retreat_vec -= to_threat.normalized() * weight

		if retreat_vec.length_squared() < 0.01:
			# Fallback to default direction if calculation fails
			retreat_vec = Vector2(0, 1)
			LogService.warning(
				"%s retreat vector too small, using fallback" % unit.callsign, "OrdersRouter"
			)

	# Calculate retreat destination
	var retreat_dir := retreat_vec.normalized()
	var retreat_dest := unit.position_m + retreat_dir * retreat_distance_m

	# Plan and start retreat (silently, no radio messages)
	if movement_adapter.plan_and_start(unit, retreat_dest):
		LogService.info(
			"%s retreating from %d threats to %s" % [unit.callsign, threats.size(), retreat_dest],
			"OrdersRouter"
		)
		emit_signal("order_applied", order)
		return true

	emit_signal("order_failed", order, "retreat_movement_failed")
	return false
```
