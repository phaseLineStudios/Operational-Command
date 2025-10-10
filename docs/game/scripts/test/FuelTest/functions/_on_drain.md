# FuelTest::_on_drain Function Reference

*Defined at:* `scripts/test/FuelTest.gd` (lines 284–289)</br>
*Belongs to:* [FuelTest](../../FuelTest.md)

**Signature**

```gdscript
func _on_drain() -> void
```

## Source

```gdscript
func _on_drain() -> void:
	var st: UnitFuelState = fuel.get_fuel_state(rx.id)
	if st != null:
		st.state_fuel = max(0.0, min(st.fuel_capacity, st.fuel_capacity * 0.05))
```
