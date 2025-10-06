# PathGrid::debug_weight_at_cell Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 739–746)</br>
*Belongs to:* [PathGrid](../PathGrid.md)

**Signature**

```gdscript
func debug_weight_at_cell(c: Vector2i) -> float
```

## Description

Weight at cell (or INF if OOB/solid).

## Source

```gdscript
func debug_weight_at_cell(c: Vector2i) -> float:
	if _astar == null or not _astar.is_in_boundsv(c):
		return INF
	if _astar.is_point_solid(c):
		return INF
	return _astar.get_point_weight_scale(c)
```
