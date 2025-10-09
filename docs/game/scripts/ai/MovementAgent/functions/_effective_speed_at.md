# MovementAgent::_effective_speed_at Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 194–220)</br>
*Belongs to:* [MovementAgent](../../MovementAgent.md)

**Signature**

```gdscript
func _effective_speed_at(p_m: Vector2) -> float
```

## Description

Function does also include the fuel system penalties for the AI

## Source

```gdscript
func _effective_speed_at(p_m: Vector2) -> float:
	if not grid:
		var v := base_speed_mps
		if _fuel and unit_id != "":
			v *= _fuel.speed_mult(unit_id)
		return v

	var cell := grid.world_to_cell(p_m)
	if not grid._in_bounds(cell):
		var v := base_speed_mps
		if _fuel and unit_id != "":
			v *= _fuel.speed_mult(unit_id)
		return v

	if grid._astar and grid._astar.is_in_boundsv(cell) and grid._astar.is_point_solid(cell):
		return 0.0

	var w := 1.0
	if grid._astar and grid._astar.is_in_boundsv(cell):
		w = max(grid._astar.get_point_weight_scale(cell), 0.001)

	var v := base_speed_mps / w
	if _fuel and unit_id != "":
		v *= _fuel.speed_mult(unit_id)
	return v
```
