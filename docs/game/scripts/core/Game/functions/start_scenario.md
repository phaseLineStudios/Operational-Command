# Game::start_scenario Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 71–77)</br>
*Belongs to:* [Game](../Game.md)

**Signature**

```gdscript
func start_scenario(prim: Array[StringName]) -> void
```

## Description

Start mission

## Source

```gdscript
func start_scenario(prim: Array[StringName]) -> void:
	if current_scenario == null:
		push_error("No scenario loaded. Cannot start scenario")
		return
	resolution.start(prim, current_scenario.id)
```
