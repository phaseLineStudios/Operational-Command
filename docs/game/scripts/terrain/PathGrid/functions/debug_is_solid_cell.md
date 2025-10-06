# PathGrid::debug_is_solid_cell Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 748–751)</br>
*Belongs to:* [PathGrid](../PathGrid.md)

**Signature**

```gdscript
func debug_is_solid_cell(c: Vector2i) -> bool
```

## Description

True if solid.

## Source

```gdscript
func debug_is_solid_cell(c: Vector2i) -> bool:
	return _astar != null and _astar.is_in_boundsv(c) and _astar.is_point_solid(c)
```
