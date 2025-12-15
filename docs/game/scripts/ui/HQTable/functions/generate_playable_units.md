# HQTable::generate_playable_units Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 329–384)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func generate_playable_units(slots: Array[UnitSlotData]) -> Array[ScenarioUnit]
```

- **slots**: Array of UnitSlotData describing player-assignable slots.
- **Return Value**: Array[ScenarioUnit] created from the active loadout assignments.

## Description

Build the list of playable units from scenario slots and current loadout.
Assigns callsigns, positions, affiliation, and marks them as playable.

## Source

```gdscript
func generate_playable_units(slots: Array[UnitSlotData]) -> Array[ScenarioUnit]:
	var units: Array[ScenarioUnit] = []
	var loadout := Game.current_scenario_loadout
	var assignments: Array = loadout.get("assignments", [])
	var callsigns := []
	for slot in slots:
		var key := slot.key

		var unit_data: UnitData
		for assignment in assignments:
			var slot_id: String = assignment.get("slot_id", "")
			if key == slot_id:
				var unit_id: String = assignment.get("unit_id", "")
				unit_data = ContentDB.get_unit(unit_id)

				var su := ScenarioUnit.new()
				su.id = unit_data.id + slot_id
				su.unit = unit_data
				su.affiliation = ScenarioUnit.Affiliation.FRIEND
				su.callsign = slot.callsign
				su.position_m = slot.start_position
				su.playable = true

				# Restore saved state from campaign save if available
				if Game.current_save:
					var saved_state := Game.current_save.get_unit_state(unit_id)
					if not saved_state.is_empty():
						su.state_strength = saved_state.get("state_strength", unit_data.strength)
						su.state_injured = saved_state.get("state_injured", 0.0)
						su.state_equipment = saved_state.get("state_equipment", 1.0)
						su.cohesion = saved_state.get("cohesion", 1.0)
						unit_data.experience = saved_state.get("experience", unit_data.experience)
						var saved_ammo = saved_state.get("state_ammunition", {})
						if saved_ammo is Dictionary and not saved_ammo.is_empty():
							su.state_ammunition = saved_ammo.duplicate()
						else:
							su.state_ammunition = unit_data.ammunition.duplicate()
					else:
						su.state_strength = unit_data.strength
						su.state_injured = 0.0
						su.state_equipment = 1.0
						su.cohesion = 1.0
						su.state_ammunition = unit_data.ammunition.duplicate()
				else:
					su.state_strength = unit_data.strength
					su.state_injured = 0.0
					su.state_equipment = 1.0
					su.cohesion = 1.0
					su.state_ammunition = unit_data.ammunition.duplicate()

				units.append(su)
				callsigns.append(slot.callsign)

	return units
```
