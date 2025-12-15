# ArtilleryController::tick Function Reference

*Defined at:* `scripts/sim/systems/ArtilleryController.gd` (lines 238–332)</br>
*Belongs to:* [ArtilleryController](../../ArtilleryController.md)

**Signature**

```gdscript
func tick(delta: float) -> void
```

## Description

Tick active fire missions

## Source

```gdscript
func tick(delta: float) -> void:
	# Process active fire missions
	for i in range(_active_missions.size() - 1, -1, -1):
		var mission: FireMission = _active_missions[i]
		mission.time_elapsed += delta

		# Process each round individually
		while mission.current_round < mission.total_rounds:
			var round_shot_time := _get_round_shot_time(mission, mission.current_round)

			# Check if it's time to fire this round
			if mission.time_elapsed >= round_shot_time:
				# Emit shot signal for this round
				LogService.debug(
					(
						"Emitting rounds_shot for %s (round %d/%d)"
						% [mission.unit_id, mission.current_round + 1, mission.total_rounds]
					),
					"ArtilleryController"
				)
				emit_signal(
					"rounds_shot", mission.unit_id, mission.target_pos, mission.ammo_type, 1
				)

				# Move to next round
				mission.current_round += 1
			else:
				# Haven't reached this round's shot time yet
				break

		# Call "Splash" warning before first impact
		if (
			not mission.splash_called
			and mission.current_round > 0
			and (
				mission.time_elapsed
				>= mission.shot_delay + mission.flight_time - splash_warning_time
			)
		):
			emit_signal(
				"rounds_splash",
				mission.unit_id,
				mission.target_pos,
				mission.ammo_type,
				mission.total_rounds
			)
			mission.splash_called = true

		# Check for impacts (process all rounds that should have impacted by now)
		var rounds_impacted := 0
		for round_idx in range(mission.total_rounds):
			var round_shot_time := _get_round_shot_time(mission, round_idx)
			var round_impact_time := round_shot_time + mission.flight_time

			if mission.time_elapsed >= round_impact_time:
				rounds_impacted += 1

		# Emit impact signals for any newly impacted rounds
		# We track how many have impacted before, so we only emit new ones
		var prev_impacted: float = mission.get_meta("prev_impacted", 0)
		if rounds_impacted > prev_impacted:
			for round_idx in range(prev_impacted, rounds_impacted):
				LogService.debug(
					(
						"Emitting rounds_impact for %s (round %d/%d)"
						% [mission.unit_id, round_idx + 1, mission.total_rounds]
					),
					"ArtilleryController"
				)
				emit_signal(
					"rounds_impact", mission.unit_id, mission.target_pos, mission.ammo_type, 1, 0.0
				)

			mission.set_meta("prev_impacted", rounds_impacted)

		# Mission complete when all rounds have impacted
		if rounds_impacted >= mission.total_rounds:
			_process_impact(mission)
			_active_missions.remove_at(i)

	# Process pending BDA reports
	for i in range(_pending_bda.size() - 1, -1, -1):
		var bda: Dictionary = _pending_bda[i]
		bda["time_remaining"] -= delta

		if bda["time_remaining"] <= 0.0:
			emit_signal(
				"battle_damage_assessment",
				bda["observer_id"],
				bda["target_pos"],
				bda["description"]
			)
			_pending_bda.remove_at(i)
```
