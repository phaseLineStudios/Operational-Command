# MissionResolution::_score_breakdown Function Reference

*Defined at:* `scripts/core/MissionResolution.gd` (lines 171–186)</br>
*Belongs to:* [MissionResolution](../MissionResolution.md)

**Signature**

```gdscript
func _score_breakdown() -> Dictionary
```

## Source

```gdscript
func _score_breakdown() -> Dictionary:
	var objective_states := func(id):
		return _objective_states.get(id, ObjectiveState.PENDING) == ObjectiveState.SUCCESS

	return {
		"primary_success":
		(
			(primary_objectives.filter(func(id): return objective_states.call(id)).size())
			* score_primary_success
		),
		"friendly_casualties": _casualties.friendly * score_friendly_casualty,
		"enemy_casualties": _casualties.enemy * score_enemy_casualty,
		"units_lost": _units_lost * score_unit_lost,
		"time_penalty_applied_on_finalize":
		int(floor((_elapsed_s / 60.0) * score_time_penalty_per_min)),
	}
```
