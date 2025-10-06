# MissionResolution::_reset Function Reference

*Defined at:* `scripts/core/MissionResolution.gd` (lines 147–156)</br>
*Belongs to:* [MissionResolution](../MissionResolution.md)

**Signature**

```gdscript
func _reset() -> void
```

## Description

Clear all state.

## Source

```gdscript
func _reset() -> void:
	_objective_states.clear()
	_casualties = {"friendly": 0, "enemy": 0}
	_units_lost = 0
	_elapsed_s = 0.0
	_total_score = 0
	_outcome = MissionOutcome.UNDECIDED
	_is_final = false
```
