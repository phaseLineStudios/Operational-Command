# MissionResolution::_recompute_score Function Reference

*Defined at:* `scripts/core/MissionResolution.gd` (lines 157–170)</br>
*Belongs to:* [MissionResolution](../MissionResolution.md)

**Signature**

```gdscript
func _recompute_score() -> void
```

## Source

```gdscript
func _recompute_score() -> void:
	var score := 0
	for id in primary_objectives:
		if _objective_states.get(id, ObjectiveState.PENDING) == ObjectiveState.SUCCESS:
			score += score_primary_success
	score += _casualties.enemy * score_enemy_casualty
	score += _casualties.friendly * score_friendly_casualty
	score += _units_lost * score_unit_lost

	if score != _total_score:
		_total_score = score
		emit_signal("score_changed", _total_score)
```
