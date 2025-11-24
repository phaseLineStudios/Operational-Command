# Game::_award_experience_to_units Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 249–306)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func _award_experience_to_units() -> void
```

## Description

Award experience to playable units after mission completion.
Base XP for survival, bonus for success.

## Source

```gdscript
func _award_experience_to_units() -> void:
	if not current_scenario or not current_scenario.playable_units:
		return

	if not current_save:
		LogService.debug("No save to persist experience to", "Game")
		return

	# Determine if mission was successful
	var outcome: int = current_scenario_summary.get("outcome", 3)  # FAILED = 3
	var success: bool = outcome == 1  # SUCCESS = 1

	# Base XP: 10 for survival
	# Bonus XP: +15 for mission success
	var base_xp := 10.0
	var success_bonus := 15.0 if success else 0.0
	var total_xp := base_xp + success_bonus

	for su in current_scenario.playable_units:
		if not (su is ScenarioUnit) or not su.unit:
			continue

		# Only award XP if unit survived (strength > 0)
		if su.state_strength <= 0.0:
			continue

		# Award experience
		su.unit.experience += total_xp

		# Update saved state with new experience
		if current_save:
			var saved_state := current_save.get_unit_state(su.unit.id)
			if saved_state.is_empty():
				# Create new state entry
				saved_state = {
					"state_strength": su.state_strength,
					"state_injured": su.state_injured,
					"state_equipment": su.state_equipment,
					"cohesion": su.cohesion,
					"state_ammunition": su.state_ammunition.duplicate(),
					"experience": su.unit.experience,
				}
			else:
				# Update existing entry
				saved_state["experience"] = su.unit.experience

			current_save.update_unit_state(su.unit.id, saved_state)

		LogService.info(
			"Awarded %.1f XP to %s (now %.1f total)" % [total_xp, su.unit.id, su.unit.experience],
			"Game"
		)

	LogService.info(
		"Awarded experience: base=%.1f, success_bonus=%.1f" % [base_xp, success_bonus], "Game"
	)
```
