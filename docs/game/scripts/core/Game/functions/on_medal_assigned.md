# Game::on_medal_assigned Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 310–354)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func on_medal_assigned(medal: String, recipient_name: String) -> void
```

## Description

Handle medal assignment in debrief
Awards bonus experience to the recipient unit

## Source

```gdscript
func on_medal_assigned(medal: String, recipient_name: String) -> void:
	if not current_scenario or not current_scenario.playable_units:
		return

	# Find the unit by name
	var found_unit: ScenarioUnit = null
	for su in current_scenario.playable_units:
		if su and su.unit and su.unit.title == recipient_name:
			found_unit = su
			break

	if not found_unit:
		LogService.warn("Medal recipient not found: %s" % recipient_name, "Game")
		return

	# Award bonus XP for medal (25 XP)
	var medal_bonus := 25.0
	found_unit.unit.experience += medal_bonus

	# Update saved state
	if current_save:
		var saved_state := current_save.get_unit_state(found_unit.unit.id)
		if saved_state.is_empty():
			saved_state = {
				"state_strength": found_unit.state_strength,
				"state_injured": found_unit.state_injured,
				"state_equipment": found_unit.state_equipment,
				"cohesion": found_unit.cohesion,
				"state_ammunition": found_unit.state_ammunition.duplicate(),
				"experience": found_unit.unit.experience,
			}
		else:
			saved_state["experience"] = found_unit.unit.experience

		current_save.update_unit_state(found_unit.unit.id, saved_state)

	LogService.info(
		(
			"Awarded medal '%s' to %s (+%.1f XP, now %.1f total)"
			% [medal, recipient_name, medal_bonus, found_unit.unit.experience]
		),
		"Game"
	)
```
