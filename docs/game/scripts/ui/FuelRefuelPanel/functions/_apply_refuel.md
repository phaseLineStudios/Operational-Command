# FuelRefuelPanel::_apply_refuel Function Reference

*Defined at:* `scripts/ui/FuelRefuelPanel.gd` (lines 199–209)</br>
*Belongs to:* [FuelRefuelPanel](../../FuelRefuelPanel.md)

**Signature**

```gdscript
func _apply_refuel(uid: String, amount: float) -> float
```

## Source

```gdscript
func _apply_refuel(uid: String, amount: float) -> float:
	if "add_fuel" in _fuel:
		return float(_fuel.add_fuel(uid, amount))
	var st: UnitFuelState = _fuel.get_fuel_state(uid)
	if st == null:
		return 0.0
	var missing: float = max(0.0, st.fuel_capacity - st.state_fuel)
	var give: float = min(missing, max(0.0, amount))
	if give > 0.0:
		st.state_fuel = min(st.fuel_capacity, st.state_fuel + give)
	return give
```
