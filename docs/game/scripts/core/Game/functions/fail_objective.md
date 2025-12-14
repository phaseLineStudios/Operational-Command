# Game::fail_objective Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 236–239)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func fail_objective(id: StringName) -> void
```

## Description

Fail objective

## Source

```gdscript
func fail_objective(id: StringName) -> void:
	resolution.set_objective_state(id, MissionResolution.ObjectiveState.FAILED)
```
