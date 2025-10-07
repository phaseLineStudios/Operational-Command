# MovementAgent::move_to_m Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 107–118)</br>
*Belongs to:* [MovementAgent](../../MovementAgent.md)

**Signature**

```gdscript
func move_to_m(dest_m: Vector2) -> void
```

## Description

Command pathfind and start moving to a world-meter destination.

## Source

```gdscript
func move_to_m(dest_m: Vector2) -> void:
	if not grid:
		emit_signal("movement_blocked", "no-grid")
		return
	var path := grid.find_path_m(sim_pos_m, dest_m)
	if path.is_empty():
		_moving = false
		emit_signal("movement_blocked", "no-path")
		return
	_set_path(path)
```
