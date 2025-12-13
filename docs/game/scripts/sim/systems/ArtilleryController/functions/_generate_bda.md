# ArtilleryController::_generate_bda Function Reference

*Defined at:* `scripts/sim/systems/ArtilleryController.gd` (lines 356–397)</br>
*Belongs to:* [ArtilleryController](../../ArtilleryController.md)

**Signature**

```gdscript
func _generate_bda(mission: FireMission) -> void
```

## Description

Generate battle damage assessment from observer units

## Source

```gdscript
func _generate_bda(mission: FireMission) -> void:
	# Find friendly units near the impact point that can observe
	# Uses distance-based checks (artillery impacts are highly visible)
	for unit_id in _units.keys():
		var su: ScenarioUnit = _units[unit_id]
		if not su:
			continue

		# Skip the firing unit
		if unit_id == mission.unit_id:
			continue

		var pos: Vector2 = _positions.get(unit_id, Vector2.INF)
		if pos == Vector2.INF:
			continue

		# Check if within spotting range (artillery impacts are visible at distance)
		var distance: float = pos.distance_to(mission.target_pos)
		if distance > su.unit.spot_m:
			continue

		# Generate BDA from first observer in range with random delay
		var description := _generate_bda_description(mission)
		var bda_delay: float = _rng.randf_range(bda_delay_min, bda_delay_max)

		_pending_bda.append(
			{
				"observer_id": unit_id,
				"target_pos": mission.target_pos,
				"description": description,
				"time_remaining": bda_delay
			}
		)

		LogService.debug(
			"Scheduled BDA from %s in %.1fs" % [unit_id, bda_delay], "ArtilleryController"
		)

		# Only one BDA per mission
		break
```
