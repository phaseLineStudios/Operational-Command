# ArtilleryController::tick Function Reference

*Defined at:* `scripts/sim/systems/ArtilleryController.gd` (lines 197–233)</br>
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
	for i in range(_active_missions.size() - 1, -1, -1):
		var mission: FireMission = _active_missions[i]
		mission.time_elapsed += delta

		# Call "Shot" once at the start
		if not mission.shot_called:
			LogService.debug("Emitting rounds_shot for %s" % mission.unit_id, "ArtilleryController")
			emit_signal(
				"rounds_shot",
				mission.unit_id,
				mission.target_pos,
				mission.ammo_type,
				mission.rounds
			)
			mission.shot_called = true

		# Call "Splash" before impact
		if (
			not mission.splash_called
			and mission.time_elapsed >= mission.flight_time - splash_warning_time
		):
			emit_signal(
				"rounds_splash",
				mission.unit_id,
				mission.target_pos,
				mission.ammo_type,
				mission.rounds
			)
			mission.splash_called = true

		# Impact
		if mission.time_elapsed >= mission.flight_time:
			_process_impact(mission)
			_active_missions.remove_at(i)
```
