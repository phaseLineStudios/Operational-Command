# Game::_snapshot_mission_start_states Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 432–469)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func _snapshot_mission_start_states(scenario: ScenarioData) -> void
```

## Description

Snapshot unit states at mission start (for replay support).
This captures the unit state BEFORE the mission begins, so replays start fresh.

## Source

```gdscript
func _snapshot_mission_start_states(scenario: ScenarioData) -> void:
	if not current_save or not scenario or not scenario.playable_units:
		return

	var mission_id := scenario.id

	# Check if we already have a snapshot for this mission
	if current_save.mission_start_states.has(mission_id):
		LogService.debug("Mission start states already captured for %s" % mission_id, "Game")
		return

	# Capture current unit states
	var snapshot := {}
	for su in scenario.playable_units:
		if not (su is ScenarioUnit) or not su.unit:
			continue

		# Use current unit_states (or defaults if first time)
		var unit_state := current_save.get_unit_state(su.unit.id)
		if unit_state.is_empty():
			# First time - use template defaults
			unit_state = {
				"state_strength": su.unit.strength,
				"state_injured": 0.0,
				"state_equipment": 1.0,
				"cohesion": 1.0,
				"state_ammunition": su.unit.ammunition.duplicate(),
				"experience": su.unit.experience,
			}

		snapshot[su.unit.id] = unit_state.duplicate()

	current_save.mission_start_states[mission_id] = snapshot
	LogService.info(
		"Captured mission start states for %s (%d units)" % [mission_id, snapshot.size()], "Game"
	)
```
