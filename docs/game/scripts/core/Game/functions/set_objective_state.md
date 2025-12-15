# Game::set_objective_state Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 240–243)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func set_objective_state(id: StringName, state: MissionResolution.ObjectiveState) -> void
```

## Description

Set objective state wrapper

## Source

```gdscript
func set_objective_state(id: StringName, state: MissionResolution.ObjectiveState) -> void:
	resolution.set_objective_state(id, state)
```
