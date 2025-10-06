# MovementAgent::_debug_current_cell Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 160–165)</br>
*Belongs to:* [MovementAgent](../MovementAgent.md)

**Signature**

```gdscript
func _debug_current_cell() -> Vector2i
```

## Description

Get the agent's current cell (if grid exists).

## Source

```gdscript
func _debug_current_cell() -> Vector2i:
	if grid == null:
		return Vector2i(-1, -1)
	return grid.world_to_cell(sim_pos_m)
```
