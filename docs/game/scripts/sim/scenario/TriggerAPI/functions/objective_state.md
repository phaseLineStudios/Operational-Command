# TriggerAPI::objective_state Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 46–51)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func objective_state(id: StringName) -> int
```

- **id**: Objective ID.
- **Return Value**: Current objective state as int.

## Description

Get current objective state via summary payload.

## Source

```gdscript
func objective_state(id: StringName) -> int:
	var d := Game.resolution.to_summary_payload()
	var o: Dictionary = d.get("objectives", {})
	return int(o.get(id, MissionResolution.ObjectiveState.PENDING))
```
