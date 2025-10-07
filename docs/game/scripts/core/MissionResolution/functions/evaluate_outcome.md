# MissionResolution::evaluate_outcome Function Reference

*Defined at:* `scripts/core/MissionResolution.gd` (lines 92–112)</br>
*Belongs to:* [MissionResolution](../../MissionResolution.md)

**Signature**

```gdscript
func evaluate_outcome() -> MissionOutcome
```

## Description

Compute current best-guess outcome (not final).

## Source

```gdscript
func evaluate_outcome() -> MissionOutcome:
	if _is_final:
		return _outcome
	var prim_total := primary_objectives.size()
	var prim_success := 0
	var prim_failed := 0
	for id in primary_objectives:
		match _objective_states.get(id, ObjectiveState.PENDING):
			ObjectiveState.SUCCESS:
				prim_success += 1
			ObjectiveState.FAILED:
				prim_failed += 1
	if prim_failed > 0:
		return MissionOutcome.FAILED
	if prim_success == prim_total and prim_total > 0:
		return MissionOutcome.SUCCESS
	if _total_score >= prim_total * (score_primary_success * 0.6):
		return MissionOutcome.PARTIAL
	return MissionOutcome.UNDECIDED
```
