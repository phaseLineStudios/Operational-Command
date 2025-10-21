# PathGrid::world_to_cell Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 489–492)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func world_to_cell(p_m: Vector2) -> Vector2i
```

## Description

Convert world meters -> grid cell.

## Source

```gdscript
func world_to_cell(p_m: Vector2) -> Vector2i:
	return _to_cell(p_m)
```
