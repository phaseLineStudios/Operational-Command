# UnitSelect::_save_temp_unit_states Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 913–931)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _save_temp_unit_states() -> void
```

## Description

Save temporary unit states back to campaign save

## Source

```gdscript
func _save_temp_unit_states() -> void:
	if not Game.current_save:
		return

	for unit_id in _temp_scenario_units.keys():
		var su: ScenarioUnit = _temp_scenario_units[unit_id]
		if su and su.unit:
			var state := {
				"state_strength": su.state_strength,
				"state_injured": su.state_injured,
				"state_equipment": su.state_equipment,
				"cohesion": su.cohesion,
				"state_ammunition": su.state_ammunition.duplicate(),
				"experience": su.unit.experience,
			}
			Game.current_save.update_unit_state(su.unit.id, state)

	# Persist to disk
	Persistence.save_to_file(Game.current_save)
```
