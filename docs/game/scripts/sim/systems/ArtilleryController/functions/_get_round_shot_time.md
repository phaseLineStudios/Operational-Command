# ArtilleryController::_get_round_shot_time Function Reference

*Defined at:* `scripts/sim/systems/ArtilleryController.gd` (lines 334–344)</br>
*Belongs to:* [ArtilleryController](../../ArtilleryController.md)

**Signature**

```gdscript
func _get_round_shot_time(mission: FireMission, round_index: int) -> float
```

## Description

Calculate when a specific round should be fired

## Source

```gdscript
func _get_round_shot_time(mission: FireMission, round_index: int) -> float:
	var time := mission.shot_delay

	# Add intervals for all previous rounds
	for i in range(round_index):
		if i < mission.round_intervals.size():
			time += mission.round_intervals[i]

	return time
```
