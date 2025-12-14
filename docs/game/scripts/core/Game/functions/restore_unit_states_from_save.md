# Game::restore_unit_states_from_save Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 418–473)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func restore_unit_states_from_save(scenario: ScenarioData) -> void
```

## Description

Restore unit states from the current campaign save.
Called when a scenario is selected to apply persistent state across missions.

## Source

```gdscript
func restore_unit_states_from_save(scenario: ScenarioData) -> void:
	if not current_save:
		LogService.debug("No save to restore from", "Game")
		return

	if not scenario or not scenario.playable_units:
		LogService.debug("No scenario playable units to restore", "Game")
		return

	var restored_count := 0

	for su in scenario.playable_units:
		if not (su is ScenarioUnit) or not su.unit:
			continue

		var unit_id := su.unit.id
		var saved_state := current_save.get_unit_state(unit_id)

		if saved_state.is_empty():
			LogService.debug("No saved state for unit: %s, using defaults" % unit_id, "Game")
			# Initialize with template values
			su.state_strength = su.unit.strength
			su.state_injured = 0.0
			su.state_equipment = 1.0
			su.cohesion = 1.0
			su.state_ammunition = su.unit.ammunition.duplicate()
			continue

		# Restore saved state
		su.state_strength = saved_state.get("state_strength", su.unit.strength)
		su.state_injured = saved_state.get("state_injured", 0.0)
		su.state_equipment = saved_state.get("state_equipment", 1.0)
		su.cohesion = saved_state.get("cohesion", 1.0)

		# Restore experience
		su.unit.experience = saved_state.get("experience", su.unit.experience)

		# Restore ammunition state
		var saved_ammo = saved_state.get("state_ammunition", {})
		if saved_ammo is Dictionary and not saved_ammo.is_empty():
			su.state_ammunition = saved_ammo.duplicate()
		else:
			su.state_ammunition = su.unit.ammunition.duplicate()

		restored_count += 1
		LogService.debug(
			(
				"Restored state for %s: strength=%.1f, injured=%.1f, cohesion=%.2f"
				% [unit_id, su.state_strength, su.state_injured, su.cohesion]
			),
			"Game"
		)

	LogService.info("Restored %d unit states from save" % restored_count, "Game")
```
