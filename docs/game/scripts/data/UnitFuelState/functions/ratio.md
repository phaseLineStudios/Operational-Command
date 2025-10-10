# UnitFuelState::ratio Function Reference

*Defined at:* `scripts/data/UnitFuelState.gd` (lines 20–23)</br>
*Belongs to:* [UnitFuelState](../../UnitFuelState.md)

**Signature**

```gdscript
func ratio() -> float
```

## Description

Calculates and returns the current fuel ratio for the unit.
The value is clamped between 0.0 and 1.0 to represent the percentage of fuel remaining.
Returns 0.0 if the unit has no valid fuel capacity defined.

## Source

```gdscript
func ratio() -> float:
	if fuel_capacity <= 0.0:
		return 0.0
	return clamp(state_fuel / fuel_capacity, 0.0, 1.0)
```
