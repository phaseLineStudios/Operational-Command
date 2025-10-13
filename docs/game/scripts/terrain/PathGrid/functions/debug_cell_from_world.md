# PathGrid::debug_cell_from_world Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 729–732)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func debug_cell_from_world(p_m: Vector2) -> Vector2i
```

## Description

Return grid cell for world meters.

## Source

```gdscript
func debug_cell_from_world(p_m: Vector2) -> Vector2i:
	return _to_cell(p_m)
```
