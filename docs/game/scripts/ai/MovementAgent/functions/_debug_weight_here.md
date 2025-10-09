# MovementAgent::_debug_weight_here Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 290–300)</br>
*Belongs to:* [MovementAgent](../../MovementAgent.md)

**Signature**

```gdscript
func _debug_weight_here() -> float
```

## Description

Read current cell weight safely.

## Source

```gdscript
func _debug_weight_here() -> float:
	if grid == null or grid._astar == null:
		return 1.0
	var c := _debug_current_cell()
	if not grid._in_bounds(c) or not grid._astar.is_in_boundsv(c):
		return 1.0
	if grid._astar.is_point_solid(c):
		return INF
	return max(grid._astar.get_point_weight_scale(c), 0.001)
```
