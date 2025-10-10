# FuelRefuelPanel::_on_half Function Reference

*Defined at:* `scripts/ui/FuelRefuelPanel.gd` (lines 126–139)</br>
*Belongs to:* [FuelRefuelPanel](../../FuelRefuelPanel.md)

**Signature**

```gdscript
func _on_half() -> void
```

## Source

```gdscript
func _on_half() -> void:
	for key in _sliders.keys():
		var id: String = key as String
		var st: UnitFuelState = _fuel.get_fuel_state(id)
		if st == null:
			continue
		var missing: float = max(0.0, st.fuel_capacity - st.state_fuel)
		var half: float = min(missing * 0.5, _depot)
		var sl: HSlider = _sliders[id]
		sl.max_value = min(missing, _depot)
		sl.value = half
	_value_labels_refresh()
```
