# PathGrid::cell_to_world_center_m Function Reference

*Defined at:* `scripts/terrain/PathGrid.gd` (lines 494–497)</br>
*Belongs to:* [PathGrid](../../PathGrid.md)

**Signature**

```gdscript
func cell_to_world_center_m(c: Vector2i) -> Vector2
```

## Description

Convert grid cell -> world meters (cell center).

## Source

```gdscript
func cell_to_world_center_m(c: Vector2i) -> Vector2:
	return _cell_center_m(c)
```
