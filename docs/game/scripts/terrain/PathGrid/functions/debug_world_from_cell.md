# PathGrid::debug_world_from_cell Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 734–737)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func debug_world_from_cell(c: Vector2i) -> Vector2
```

## Description

Return cell center in meters.

## Source

```gdscript
func debug_world_from_cell(c: Vector2i) -> Vector2:
	return _cell_center_m(c)
```
