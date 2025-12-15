# Game::save_campaign_state Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 545–589)</br>
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

	var is_forward_progress := false

	# Update current mission
	if current_scenario:
		current_save.current_mission = current_scenario.id

		# Mark mission as completed if successful
		if current_scenario_summary.has("outcome"):
			var outcome = current_scenario_summary.get("outcome")
			if outcome == MissionResolution.MissionOutcome.SUCCESS:
				current_save.complete_mission(current_scenario.id)
				LogService.info("Marked mission %s as completed" % current_scenario.id, "Game")

				# Check if this is forward progress (new furthest mission)
				is_forward_progress = (current_scenario.id == current_save.furthest_mission)

	# ONLY persist unit states if this is forward progress
	# This prevents time paradoxes when replaying earlier missions
	if is_forward_progress and current_scenario and current_scenario.playable_units:
		LogService.info("Forward progress detected - persisting unit states", "Game")
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
	elif not is_forward_progress:
		LogService.info(
			"Replay detected - NOT persisting unit states (preventing time paradox)", "Game"
		)

	# Save to disk
	Persistence.save_to_file(current_save)
```
