# FuelSystem::is_low Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 94–102)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func is_low(unit_id: String) -> bool
```

## Source

```gdscript
func is_low(unit_id: String) -> bool:
	## True if current fraction <= low threshold and > critical threshold.
	var s: UnitFuelState = _fuel.get(unit_id) as UnitFuelState
	if s == null or s.fuel_capacity <= 0.0:
		return false
	var r: float = s.ratio()
	return s.state_fuel > 0.0 and r <= s.fuel_low_threshold and r > s.fuel_critical_threshold
```
