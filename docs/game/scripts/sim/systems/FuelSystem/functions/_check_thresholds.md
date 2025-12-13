# FuelSystem::_check_thresholds Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 204–234)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func _check_thresholds(uid: String, before: float, after: float, su: ScenarioUnit) -> void
```

## Source

```gdscript
func _check_thresholds(uid: String, before: float, after: float, su: ScenarioUnit) -> void:
	## Emit threshold events and pause or resume the ScenarioUnit when crossing 0.
	var st: UnitFuelState = _fuel.get(uid) as UnitFuelState
	if st == null:
		return
	var cap: float = max(1.0, st.fuel_capacity)
	var before_r: float = clamp(before / cap, 0.0, 1.0)
	var after_r: float = clamp(after / cap, 0.0, 1.0)

	if after <= 0.0 and before > 0.0:
		emit_signal("fuel_empty", uid)
		if not _immobilized.get(uid, false):
			_immobilized[uid] = true
			su.pause_move()
			emit_signal("unit_immobilized_fuel_out", uid)
	elif (
		after_r <= st.fuel_critical_threshold
		and before_r > st.fuel_critical_threshold
		and after > 0.0
	):
		emit_signal("fuel_critical", uid)
	elif after_r <= st.fuel_low_threshold and before_r > st.fuel_low_threshold and after > 0.0:
		emit_signal("fuel_low", uid)

	if before <= 0.0 and after > 0.0:
		if _immobilized.get(uid, false):
			_immobilized[uid] = false
			su.resume_move()
			emit_signal("unit_mobilized_after_refuel", uid)
```
