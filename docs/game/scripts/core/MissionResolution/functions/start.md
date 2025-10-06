# MissionResolution::start Function Reference

*Defined at:* `scripts/core/MissionResolution.gd` (lines 40–49)</br>
*Belongs to:* [MissionResolution](../MissionResolution.md)

**Signature**

```gdscript
func start(prim: Array[StringName], scenario: StringName = &"") -> void
```

## Description

Initialize for a mission.

## Source

```gdscript
func start(prim: Array[StringName], scenario: StringName = &"") -> void:
	_reset()
	scenario_id = scenario if scenario != &"" else scenario_id
	primary_objectives = prim
	for id in prim:
		_objective_states[id] = ObjectiveState.PENDING
	_recompute_score()
	LogService.info("Started Scenario", "MissionResolution.gd:47")
```
