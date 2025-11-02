# TerrainRender::nav_estimate_time_s Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 444–447)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func nav_estimate_time_s(path_m: PackedVector2Array, base_speed_mps: float, profile: int) -> float
```

## Description

Estimate travel time (seconds) along a path for a given base speed and profile

## Source

```gdscript
func nav_estimate_time_s(path_m: PackedVector2Array, base_speed_mps: float, profile: int) -> float:
	if not path_grid:
		return INF
	return path_grid.estimate_travel_time_s(path_m, base_speed_mps, profile)
```
