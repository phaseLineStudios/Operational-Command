# FuelRefuelPanel::_build_rows Function Reference

*Defined at:* `scripts/ui/FuelRefuelPanel.gd` (lines 58–98)</br>
*Belongs to:* [FuelRefuelPanel](../../FuelRefuelPanel.md)

**Signature**

```gdscript
func _build_rows() -> void
```

## Source

```gdscript
func _build_rows() -> void:
	for c in _rows_box.get_children():
		c.queue_free()
	_sliders.clear()
	_value_labels.clear()

	for su in _units:
		if su == null:
			continue
		var st: UnitFuelState = _fuel.get_fuel_state(su.id)
		if st == null:
			continue
		var missing: float = max(0.0, st.fuel_capacity - st.state_fuel)

		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_rows_box.add_child(row)

		var left_lbl := Label.new()
		left_lbl.custom_minimum_size = Vector2(row_label_min_w, 0.0)
		left_lbl.text = _row_label_for(su, st, missing)
		row.add_child(left_lbl)

		var slider := HSlider.new()
		slider.min_value = 0.0
		slider.max_value = min(missing, _depot)
		slider.step = slider_step
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slider.value_changed.connect(_on_slider_changed.bind(su.id))
		row.add_child(slider)

		var val_lbl := Label.new()
		val_lbl.custom_minimum_size = Vector2(value_label_min_w, 0.0)
		val_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		val_lbl.text = "0.0"
		row.add_child(val_lbl)

		_sliders[su.id] = slider
		_value_labels[su.id] = val_lbl
```
