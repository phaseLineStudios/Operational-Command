# UnitSelect::_get_scenario_unit_for_id Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 859–911)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _get_scenario_unit_for_id(unit_id: String) -> ScenarioUnit
```

## Description

Get or create temporary ScenarioUnit for a unit ID

## Source

```gdscript
func _get_scenario_unit_for_id(unit_id: String) -> ScenarioUnit:
	# Check if we already have a temp instance
	if _temp_scenario_units.has(unit_id):
		return _temp_scenario_units[unit_id]

	# Check scenario.units (pre-placed units)
	if Game.current_scenario:
		for su in Game.current_scenario.units:
			if su and su.unit and su.unit.id == unit_id:
				return su

	# Create temporary ScenarioUnit for recruitable unit
	var unit := _units_by_id.get(unit_id) as UnitData
	if not unit:
		return null

	var su := ScenarioUnit.new()
	su.unit = unit
	su.affiliation = ScenarioUnit.Affiliation.FRIEND

	# Initialize with saved state if available, otherwise use defaults
	if Game.current_save:
		var saved_state := Game.current_save.get_unit_state(unit_id)
		if not saved_state.is_empty():
			su.state_strength = saved_state.get("state_strength", unit.strength)
			su.state_injured = saved_state.get("state_injured", 0.0)
			su.state_equipment = saved_state.get("state_equipment", 1.0)
			su.cohesion = saved_state.get("cohesion", 1.0)
			unit.experience = saved_state.get("experience", unit.experience)
			var saved_ammo = saved_state.get("state_ammunition", {})
			if saved_ammo is Dictionary and not saved_ammo.is_empty():
				su.state_ammunition = saved_ammo.duplicate()
			else:
				su.state_ammunition = unit.ammunition.duplicate()
		else:
			# No saved state, use template defaults
			su.state_strength = unit.strength
			su.state_injured = 0.0
			su.state_equipment = 1.0
			su.cohesion = 1.0
			su.state_ammunition = unit.ammunition.duplicate()
	else:
		# No save, use template defaults
		su.state_strength = unit.strength
		su.state_injured = 0.0
		su.state_equipment = 1.0
		su.cohesion = 1.0
		su.state_ammunition = unit.ammunition.duplicate()

	_temp_scenario_units[unit_id] = su
	return su
```
