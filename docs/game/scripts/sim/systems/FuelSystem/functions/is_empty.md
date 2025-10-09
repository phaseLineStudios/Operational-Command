# FuelSystem::is_empty Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 109–116)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func is_empty(unit_id: String) -> bool
```

## Source

```gdscript
func is_empty(unit_id: String) -> bool:
	## True if current fuel is zero.
	var s: UnitFuelState = _fuel.get(unit_id) as UnitFuelState
	if s == null:
		return false
	return s.state_fuel <= 0.0
```
