# MissionResolution::to_summary_payload Function Reference

*Defined at:* `scripts/core/MissionResolution.gd` (lines 134–148)</br>
*Belongs to:* [MissionResolution](../../MissionResolution.md)

**Signature**

```gdscript
func to_summary_payload() -> Dictionary
```

## Description

Debrief/persistence payload; stable contract for other screens.

## Source

```gdscript
func to_summary_payload() -> Dictionary:
	return {
		"scenario_id": scenario_id,
		"elapsed_s": int(round(_elapsed_s)),
		"objectives": _objective_states.duplicate(true),
		"primary_objectives": primary_objectives.duplicate(),
		"casualties": _casualties.duplicate(true),
		"units_lost": _units_lost,
		"score_total": _total_score,
		"score_breakdown": _score_breakdown(),
		"outcome": _outcome,
		"losses_by_unit": _losses_by_unit.duplicate(true),
	}
```
