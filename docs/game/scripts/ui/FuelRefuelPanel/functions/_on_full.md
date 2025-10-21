# FuelRefuelPanel::_on_full Function Reference

*Defined at:* `scripts/ui/FuelRefuelPanel.gd` (lines 112–125)</br>
*Belongs to:* [FuelRefuelPanel](../../FuelRefuelPanel.md)

**Signature**

```gdscript
func _on_full() -> void
```

## Source

```gdscript
func _on_full() -> void:
	for key in _sliders.keys():
		var id: String = key as String
		var st: UnitFuelState = _fuel.get_fuel_state(id)
		if st == null:
			continue
		var missing: float = max(0.0, st.fuel_capacity - st.state_fuel)
		var can_give: float = min(missing, _depot)
		var sl: HSlider = _sliders[id]
		sl.max_value = can_give
		sl.value = can_give
	_value_labels_refresh()
```
