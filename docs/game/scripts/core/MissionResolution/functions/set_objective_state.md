# MissionResolution::set_objective_state Function Reference

*Defined at:* `scripts/core/MissionResolution.gd` (lines 60–73)</br>
*Belongs to:* [MissionResolution](../../MissionResolution.md)

**Signature**

```gdscript
func set_objective_state(id: String, state: ObjectiveState) -> void
```

## Description

Update an objective state.

## Source

```gdscript
func set_objective_state(id: String, state: ObjectiveState) -> void:
	if _is_final:
		return
	if not _objective_states.has(id):
		_objective_states[id] = ObjectiveState.PENDING
	var prev: int = _objective_states[id]
	if prev == state:
		return
	_objective_states[id] = state
	emit_signal("objective_updated", id, state)
	_recompute_score()
	LogService.trace("Changed %s's Objective state" % id, "MissionResolution.gd:67")
```
