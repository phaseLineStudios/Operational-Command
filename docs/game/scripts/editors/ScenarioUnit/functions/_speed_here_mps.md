# ScenarioUnit::_speed_here_mps Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 287–334)</br>
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
		# Apply optional behaviour speed multiplier if present
		var beh_mult := 1.0
		if has_meta("behaviour_speed_mult"):
			beh_mult = float(get_meta("behaviour_speed_mult"))
		var env_mult := 1.0
		if has_meta("env_speed_mult"):
			env_mult = float(get_meta("env_speed_mult"))
			if env_mult <= 0.0:
				env_mult = 1.0
		return speed * beh_mult * env_mult

	var c := grid.world_to_cell(p_m)
	if not grid._in_bounds(c):
		var speed := _kph_to_mps(unit.speed_kph)
		if _fuel != null:
			speed *= _fuel.speed_mult(id)
		var beh_mult := 1.0
		if has_meta("behaviour_speed_mult"):
			beh_mult = float(get_meta("behaviour_speed_mult"))
		var env_mult := 1.0
		if has_meta("env_speed_mult"):
			env_mult = float(get_meta("env_speed_mult"))
			if env_mult <= 0.0:
				env_mult = 1.0
		return speed * beh_mult * env_mult

	if grid._astar.is_in_boundsv(c) and grid._astar.is_point_solid(c):
		return 0.0

	var w: float = max(grid._astar.get_point_weight_scale(c), 0.001)
	var v := _kph_to_mps(unit.speed_kph) / w
	if _fuel != null:
		v *= _fuel.speed_mult(id)
	if has_meta("behaviour_speed_mult"):
		v *= float(get_meta("behaviour_speed_mult"))
	if has_meta("env_speed_mult"):
		var env_mult := float(get_meta("env_speed_mult"))
		if env_mult <= 0.0:
			env_mult = 1.0
		v *= env_mult
	return v
```
