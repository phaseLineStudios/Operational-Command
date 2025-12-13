# FuelSystem::get_fuel_state Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 89–93)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func get_fuel_state(unit_id: String) -> UnitFuelState
```

## Source

```gdscript
func get_fuel_state(unit_id: String) -> UnitFuelState:
	## Return the UnitFuelState for a unit, or null if not present.
	return _fuel.get(unit_id) as UnitFuelState
```
