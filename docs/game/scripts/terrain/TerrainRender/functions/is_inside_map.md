# TerrainRender::is_inside_map Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 287–290)</br>
*Belongs to:* [TerrainRender](../TerrainRender.md)

**Signature**

```gdscript
func is_inside_map(pos: Vector2) -> bool
```

## Description

API to check if position is inside map

## Source

```gdscript
func is_inside_map(pos: Vector2) -> bool:
	return margin.get_global_rect().has_point(pos)
```
