# TerrainRender::nav_find_path_m Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 429–434)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func nav_find_path_m(start_m: Vector2, goal_m: Vector2) -> PackedVector2Array
```

## Description

Request a path in terrain meters via attached PathGrid

## Source

```gdscript
func nav_find_path_m(start_m: Vector2, goal_m: Vector2) -> PackedVector2Array:
	if not path_grid:
		return PackedVector2Array()
	return path_grid.find_path_m(start_m, goal_m)
```
