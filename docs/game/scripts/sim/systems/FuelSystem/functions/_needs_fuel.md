# FuelSystem::_needs_fuel Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 335–348)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func _needs_fuel(su: ScenarioUnit) -> bool
```

## Source

```gdscript
func _needs_fuel(su: ScenarioUnit) -> bool:
	## True if the unit is not full, is alive, and is stationary.
	var st: UnitFuelState = _fuel.get(su.id) as UnitFuelState
	if st == null:
		return false
	# Don't refuel dead units
	if su.state_strength <= 0:
		return false
	# Only refuel stationary units
	if su.move_state() != ScenarioUnit.MoveState.IDLE:
		return false
	return st.state_fuel < st.fuel_capacity
```
