# UnitSelect::_populate_supply_ui Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 467–565)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _populate_supply_ui(unit: UnitData, reset_pending: bool = true) -> void
```

## Description

Populate supply UI with ammo and equipment resupply options

## Source

```gdscript
func _populate_supply_ui(unit: UnitData, reset_pending: bool = true) -> void:
	# Clear existing children immediately
	for child in _supply_vbox.get_children():
		_supply_vbox.remove_child(child)
		child.queue_free()

	if not unit:
		return

	var scenario_unit := _get_scenario_unit_for_id(unit.id)
	if not scenario_unit:
		return

	# Sync pool values from scenario (in case they were updated)
	_current_equipment_pool = Game.current_scenario.equipment_pool
	_current_ammo_pools = Game.current_scenario.ammo_pools.duplicate()

	# Initialize pending values to current values (only if reset_pending is true)
	if reset_pending:
		_pending_equipment = int(scenario_unit.state_equipment * 100.0)
		_pending_ammo.clear()
		for ammo_type in unit.ammunition.keys():
			_pending_ammo[ammo_type] = int(scenario_unit.state_ammunition.get(ammo_type, 0))

		# Capture original state ONLY on first selection of this unit
		if not _original_equipment.has(unit.id):
			_original_equipment[unit.id] = int(scenario_unit.state_equipment * 100.0)
			var unit_ammo: Dictionary = {}
			for ammo_type in unit.ammunition.keys():
				unit_ammo[ammo_type] = int(scenario_unit.state_ammunition.get(ammo_type, 0))
			_original_ammo[unit.id] = unit_ammo
			_original_equipment_pool[unit.id] = _current_equipment_pool
			_original_ammo_pools[unit.id] = _current_ammo_pools.duplicate()
			LogService.debug(
				(
					"Captured original state for %s: equipment=%d%%, pool=%d"
					% [
						unit.id,
						int(_original_equipment[unit.id]),
						int(_original_equipment_pool[unit.id])
					]
				),
				"UnitSelect"
			)

	LogService.debug(
		(
			"Populate supply UI: pool=%d, current=%d%%, pending=%d%%"
			% [
				_current_equipment_pool,
				int(scenario_unit.state_equipment * 100.0),
				_pending_equipment
			]
		),
		"UnitSelect"
	)

	# Create ScrollContainer for supply items
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_supply_vbox.add_child(scroll)

	# Create VBoxContainer inside scroll for items
	var items_vbox := VBoxContainer.new()
	items_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(items_vbox)

	# Add equipment resupply row
	_add_equipment_row(scenario_unit, items_vbox)

	# Add ammo resupply rows for each ammo type the unit has
	for ammo_type in unit.ammunition.keys():
		var capacity: int = int(unit.ammunition.get(ammo_type, 0))
		if capacity > 0:
			_add_ammo_row(scenario_unit, ammo_type, capacity, items_vbox)

	# Add spacer
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 10)
	_supply_vbox.add_child(spacer)

	# Add commit/reset buttons row (outside scroll container)
	var button_row := HBoxContainer.new()
	button_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button_row.alignment = BoxContainer.ALIGNMENT_END
	_supply_vbox.add_child(button_row)

	var reset_btn := Button.new()
	reset_btn.text = "Reset"
	reset_btn.pressed.connect(func(): _reset_resupply_pending(unit))
	button_row.add_child(reset_btn)

	var commit_btn := Button.new()
	commit_btn.text = "Commit Resupply"
	commit_btn.pressed.connect(func(): _commit_resupply(unit))
	button_row.add_child(commit_btn)
```
