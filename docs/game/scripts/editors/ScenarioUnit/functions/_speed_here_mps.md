# ScenarioUnit::_speed_here_mps Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 230–253)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func _speed_here_mps(grid: PathGrid, p_m: Vector2) -> float
```

## Description

Terrain-modified speed at a point using PathGrid weight.
_speed_here_mps also includes speed penalties for low fuel

## Source

```gdscript
func _speed_here_mps(grid: PathGrid, p_m: Vector2) -> float:
	if grid == null or grid._astar == null:
		var speed := _kph_to_mps(unit.speed_kph)
		if _fuel != null:
			speed *= _fuel.speed_mult(id)
		return speed

	var c := grid.world_to_cell(p_m)
	if not grid._in_bounds(c):
		var speed := _kph_to_mps(unit.speed_kph)
		if _fuel != null:
			speed *= _fuel.speed_mult(id)
		return speed

	if grid._astar.is_in_boundsv(c) and grid._astar.is_point_solid(c):
		return 0.0

	var w: float = max(grid._astar.get_point_weight_scale(c), 0.001)
	var v := _kph_to_mps(unit.speed_kph) / w
	if _fuel != null:
		v *= _fuel.speed_mult(id)
	return v
```
