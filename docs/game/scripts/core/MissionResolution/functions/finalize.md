# MissionResolution::finalize Function Reference

*Defined at:* `scripts/core/MissionResolution.gd` (lines 116–132)</br>
*Belongs to:* [MissionResolution](../../MissionResolution.md)

**Signature**

```gdscript
func finalize(abort: bool = false) -> Dictionary
```

## Description

Finalize the mission (moves to immutable state).

## Source

```gdscript
func finalize(abort: bool = false) -> Dictionary:
	if _is_final:
		return to_summary_payload()
	_is_final = true
	var time_penalty := int(floor((_elapsed_s / 60.0) * score_time_penalty_per_min))
	_total_score += time_penalty

	_outcome = MissionOutcome.ABORTED if abort else evaluate_outcome()
	var summary := to_summary_payload()
	emit_signal("mission_finalized", _outcome, summary)
	LogService.info(
		"Finalized Scenario with outcome: %s" % str(MissionOutcome.keys()[_outcome]),
		"MissionResolution.gd:117"
	)
	return summary
```
