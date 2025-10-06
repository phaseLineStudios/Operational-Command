# MovementAgent::_effective_speed_at Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 92–105)</br>
*Belongs to:* [MovementAgent](../MovementAgent.md)

**Signature**

```gdscript
func _effective_speed_at(p_m: Vector2) -> float
```

## Source

```gdscript
func _effective_speed_at(p_m: Vector2) -> float:
	if not grid:
		return base_speed_mps
	var cell := grid.world_to_cell(p_m)
	if not grid._in_bounds(cell):
		return base_speed_mps
	if grid._astar and grid._astar.is_in_boundsv(cell) and grid._astar.is_point_solid(cell):
		return 0.0
	var w := 1.0
	if grid._astar and grid._astar.is_in_boundsv(cell):
		w = max(grid._astar.get_point_weight_scale(cell), 0.001)
	return base_speed_mps / w
```
