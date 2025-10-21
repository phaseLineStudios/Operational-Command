# FuelSystem::_consume_tick Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 173–201)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func _consume_tick(delta: float) -> void
```

## Description

Fuel drain

## Source

```gdscript
func _consume_tick(delta: float) -> void:
	## Apply idle burn and distance-based burn. Update thresholds and immobilization.
	for key in _fuel.keys():
		var uid: String = key as String
		var su: ScenarioUnit = _su.get(uid) as ScenarioUnit
		var st: UnitFuelState = _fuel.get(uid) as UnitFuelState
		if su == null or st == null:
			continue

		var before: float = st.state_fuel

		var now_pos: Vector2 = su.position_m
		var prev_pos: Vector2 = (_prev.get(uid, now_pos) as Variant) as Vector2
		_pos[uid] = now_pos

		var idle_burn: float = max(0.0, st.fuel_idle_rate_per_s) * max(delta, 0.0)

		var dist_m: float = now_pos.distance_to(prev_pos)
		var move_mult: float = _terrain_slope_multiplier(prev_pos, now_pos)
		var move_burn: float = max(0.0, st.fuel_move_rate_per_m) * dist_m * move_mult

		var total: float = idle_burn + move_burn
		if total > 0.0:
			st.state_fuel = max(0.0, st.state_fuel - total)

		_prev[uid] = now_pos
		_check_thresholds(uid, before, st.state_fuel, su)
```
