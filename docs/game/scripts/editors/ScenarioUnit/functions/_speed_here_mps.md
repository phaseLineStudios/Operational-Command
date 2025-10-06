# ScenarioUnit::_speed_here_mps Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 192–203)</br>
*Belongs to:* [ScenarioUnit](../ScenarioUnit.md)

**Signature**

```gdscript
func _speed_here_mps(grid: PathGrid, p_m: Vector2) -> float
```

## Description

Terrain-modified speed at a point using PathGrid weight.

## Source

```gdscript
func _speed_here_mps(grid: PathGrid, p_m: Vector2) -> float:
	if grid == null or grid._astar == null:
		return _kph_to_mps(unit.speed_kph)
	var c := grid.world_to_cell(p_m)
	if not grid._in_bounds(c):
		return _kph_to_mps(unit.speed_kph)
	if grid._astar.is_in_boundsv(c) and grid._astar.is_point_solid(c):
		return 0.0
	var w: float = max(grid._astar.get_point_weight_scale(c), 0.001)
	return _kph_to_mps(unit.speed_kph) / w
```
