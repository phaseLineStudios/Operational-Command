# FuelRefuelPanel::_row_label_for Function Reference

*Defined at:* `scripts/ui/FuelRefuelPanel.gd` (lines 99–107)</br>
*Belongs to:* [FuelRefuelPanel](../../FuelRefuelPanel.md)

**Signature**

```gdscript
func _row_label_for(su: ScenarioUnit, st: UnitFuelState, missing: float) -> String
```

## Source

```gdscript
func _row_label_for(su: ScenarioUnit, st: UnitFuelState, missing: float) -> String:
	var unit_label: String = su.callsign if su.callsign != "" else su.id
	if show_missing_in_label:
		return (
			"%s  missing %.1f  (%.0f/%.0f)" % [unit_label, missing, st.state_fuel, st.fuel_capacity]
		)
	return "%s  (%.0f/%.0f)" % [unit_label, st.state_fuel, st.fuel_capacity]
```
