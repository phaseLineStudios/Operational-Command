# Game::complete_objective Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 117–120)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func complete_objective(id: StringName) -> void
```

## Description

Complete objective

## Source

```gdscript
func complete_objective(id: StringName) -> void:
	resolution.set_objective_state(id, MissionResolution.ObjectiveState.SUCCESS)
```
