# FuelSystem::_needs_fuel Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 333–340)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func _needs_fuel(su: ScenarioUnit) -> bool
```

## Source

```gdscript
func _needs_fuel(su: ScenarioUnit) -> bool:
	## True if the unit is not full.
	var st: UnitFuelState = _fuel.get(su.id) as UnitFuelState
	if st == null:
		return false
	return st.state_fuel < st.fuel_capacity
```
