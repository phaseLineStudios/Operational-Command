# FuelSystem::is_critical Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 103–110)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func is_critical(unit_id: String) -> bool
```

## Source

```gdscript
func is_critical(unit_id: String) -> bool:
	## True if current fraction <= critical threshold and > 0.
	var s: UnitFuelState = _fuel.get(unit_id) as UnitFuelState
	if s == null or s.fuel_capacity <= 0.0:
		return false
	return s.state_fuel > 0.0 and s.ratio() <= s.fuel_critical_threshold
```
