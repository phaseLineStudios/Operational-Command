# UnitSelect::_on_reinforcement_committed Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 817–857)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _on_reinforcement_committed(plan: Dictionary) -> void
```

## Description

Handle reinforcement committed

## Source

```gdscript
func _on_reinforcement_committed(plan: Dictionary) -> void:
	var remaining_pool: int = Game.current_scenario.replacement_pool

	for unit_id in plan.keys():
		var add := int(plan[unit_id])
		var unit := _units_by_id.get(unit_id) as UnitData
		if not unit:
			continue

		var scenario_unit := _get_scenario_unit_for_id(unit_id)
		if not scenario_unit:
			continue

		# Don't reinforce wiped out units
		if scenario_unit.state_strength <= 0.0:
			continue

		var current := int(scenario_unit.state_strength)
		var capacity := int(unit.strength)
		var missing: int = max(0, capacity - current)
		var actual: int = min(add, missing, remaining_pool)

		if actual > 0:
			scenario_unit.state_strength += float(actual)
			remaining_pool -= actual
			LogService.info(
				(
					"Reinforced %s: +%d personnel (now %d/%d)"
					% [unit_id, actual, int(scenario_unit.state_strength), capacity]
				),
				"UnitSelect"
			)

	# Update pool
	Game.current_scenario.replacement_pool = remaining_pool

	# Refresh UI
	if _selected_unit_for_supply:
		_populate_replacements_ui(_selected_unit_for_supply)
```
