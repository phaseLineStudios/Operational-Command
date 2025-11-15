# TriggerAPI::set_objective Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 93–96)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func set_objective(id: StringName, state: int) -> void
```

- **id**: Objective ID.
- **state**: ObjectiveState enum.

## Description

Set objective state

## Source

```gdscript
func set_objective(id: StringName, state: int) -> void:
	Game.set_objective_state(id, state)
```
