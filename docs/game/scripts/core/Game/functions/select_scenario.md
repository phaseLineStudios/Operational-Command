# Game::select_scenario Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 196–208)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func select_scenario(scenario: ScenarioData) -> void
```

## Description

Set current mission and emit `signal mission_selected`.

## Source

```gdscript
func select_scenario(scenario: ScenarioData) -> void:
	current_scenario = scenario

	# Restore unit states from save if available
	if current_save:
		# Snapshot current unit states BEFORE mission starts (for replay support)
		_snapshot_mission_start_states(scenario)
		restore_unit_states_from_save(scenario)

	LogService.trace("Set Scenario: %s" % current_scenario.id)
	emit_signal("scenario_selected", scenario.id)
```

## References

- [`signal mission_selected`](../../Game.md)
