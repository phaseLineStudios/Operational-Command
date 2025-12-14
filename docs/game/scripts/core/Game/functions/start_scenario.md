# Game::start_scenario Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 207–218)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func start_scenario(prim: Array[String]) -> void
```

## Description

Start mission

## Source

```gdscript
func start_scenario(prim: Array[String]) -> void:
	if current_scenario == null:
		push_error("No scenario loaded. Cannot start scenario")
		return
	resolution.start(prim, current_scenario.id)

	# Try to find the SimWorld in the current scene tree and spawn
	var sim := get_tree().get_root().find_child("SimWorld", true, false)
	if sim and sim.has_method("spawn_scenario_units"):
		sim.spawn_scenario_units(current_scenario)
```
