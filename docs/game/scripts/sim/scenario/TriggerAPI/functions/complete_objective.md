# TriggerAPI::complete_objective Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 83–86)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func complete_objective(id: StringName) -> void
```

- **id**: Objective ID.

## Description

Set objective state to completed.

## Source

```gdscript
func complete_objective(id: StringName) -> void:
	Game.complete_objective(id)
```
