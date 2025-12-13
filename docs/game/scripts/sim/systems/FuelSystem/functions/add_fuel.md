# FuelSystem::add_fuel Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 468–483)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func add_fuel(uid: String, amount: float) -> float
```

## Description

Directly add fuel to a unit (UI/depot use). Returns amount actually added.

## Source

```gdscript
func add_fuel(uid: String, amount: float) -> float:
	var st: UnitFuelState = _fuel.get(uid) as UnitFuelState
	if st == null or amount <= 0.0:
		return 0.0
	var su: ScenarioUnit = _su.get(uid) as ScenarioUnit
	var cap: float = st.fuel_capacity
	var cur: float = st.state_fuel
	var add: float = min(amount, max(0.0, cap - cur))
	if add <= 0.0:
		return 0.0
	var before: float = cur
	st.state_fuel = cur + add
	_check_thresholds(uid, before, st.state_fuel, su)
	return add
```
