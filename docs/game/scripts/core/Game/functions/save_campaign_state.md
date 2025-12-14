# Game::save_campaign_state Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 474–505)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func save_campaign_state() -> void
```

## Source

```gdscript
func save_campaign_state() -> void:
	if not current_save:
		push_warning("Cannot save campaign state: no active save")
		return

	# Update current mission
	if current_scenario:
		current_save.current_mission = current_scenario.id

		# Mark mission as completed if successful
		if current_scenario_summary.has("outcome"):
			var outcome = current_scenario_summary.get("outcome")
			if outcome == MissionResolution.MissionOutcome.SUCCESS:
				current_save.complete_mission(current_scenario.id)
				LogService.info("Marked mission %s as completed" % current_scenario.id, "Game")

	# Update unit states from scenario playable units
	if current_scenario and current_scenario.playable_units:
		for su in current_scenario.playable_units:
			if su is ScenarioUnit and su.unit:
				var state := {
					"state_strength": su.state_strength,
					"state_injured": su.state_injured,
					"state_equipment": su.state_equipment,
					"cohesion": su.cohesion,
					"state_ammunition": su.state_ammunition.duplicate(),
					"experience": su.unit.experience,
				}
				current_save.update_unit_state(su.unit.id, state)

	# Save to disk
	Persistence.save_to_file(current_save)
```
