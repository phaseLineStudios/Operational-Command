# HQTable::generate_playable_units Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 31–57)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func generate_playable_units(slots: Array[UnitSlotData]) -> Array[ScenarioUnit]
```

## Description

Build the list of playable units from scenario slots and current loadout.
Assigns callsigns, positions, affiliation, and marks them as playable.
[param slots] Array of UnitSlotData describing player-assignable slots.
[return] Array[ScenarioUnit] created from the active loadout assignments.

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
				units.append(su)
				callsigns.append(slot.callsign)

	LogService.trace("Generated playable units: %s" % str(callsigns), "HQTable.gd:42")
	return units
```
