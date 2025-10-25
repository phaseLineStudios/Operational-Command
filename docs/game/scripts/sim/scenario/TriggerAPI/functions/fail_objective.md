# TriggerAPI::fail_objective Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 32–35)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func fail_objective(id: StringName) -> void
```

- **id**: Objective ID.

## Description

Set objective state to failed.

## Source

```gdscript
func fail_objective(id: StringName) -> void:
	Game.complete_objective(id)
```
