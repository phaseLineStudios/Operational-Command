# UnitSelect::_add_equipment_row Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 567–622)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _add_equipment_row(scenario_unit: ScenarioUnit, container: VBoxContainer) -> void
```

## Description

Add equipment resupply row

## Source

```gdscript
func _add_equipment_row(scenario_unit: ScenarioUnit, container: VBoxContainer) -> void:
	var current_pct := int(scenario_unit.state_equipment * 100.0)

	# Row 1: Type, Pool, Current/Max
	var row1 := HBoxContainer.new()
	row1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.add_child(row1)

	var label := Label.new()
	label.text = "Equipment:"
	label.custom_minimum_size = Vector2(100, 0)
	row1.add_child(label)

	var pool_label := Label.new()
	pool_label.text = "Pool: %d" % _current_equipment_pool
	pool_label.custom_minimum_size = Vector2(80, 0)
	row1.add_child(pool_label)

	var current_label := Label.new()
	current_label.text = "%d%%" % current_pct
	current_label.custom_minimum_size = Vector2(60, 0)
	row1.add_child(current_label)

	# Row 2: Slider only
	var row2 := HBoxContainer.new()
	row2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.add_child(row2)

	var slider := HSlider.new()
	slider.min_value = 0.0
	slider.max_value = 100.0
	slider.step = 1.0
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.value_changed.connect(
		func(v: float) -> void:
			var target_pct := int(round(v))
			# Block slider from going below current value
			if target_pct < current_pct:
				slider.value = float(current_pct)
				return
			var cost := target_pct - current_pct
			var pool_after := _current_equipment_pool - cost
			if pool_after < 0:
				slider.value = float(current_pct + _current_equipment_pool)
				return
			# Update pending value only
			_pending_equipment = target_pct
			# Update labels to show preview
			current_label.text = "%d%%" % target_pct
			pool_label.text = "Pool: %d" % pool_after
	)
	row2.add_child(slider)
	# Set value after adding to tree to ensure it updates visually
	slider.set_value_no_signal(float(_pending_equipment))
```
