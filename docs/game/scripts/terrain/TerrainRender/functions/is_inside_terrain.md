# TerrainRender::is_inside_terrain Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 292–295)</br>
*Belongs to:* [TerrainRender](../TerrainRender.md)

**Signature**

```gdscript
func is_inside_terrain(pos: Vector2) -> bool
```

## Description

API to check if position is inside terrain

## Source

```gdscript
func is_inside_terrain(pos: Vector2) -> bool:
	return base_layer.get_global_rect().has_point(pos)
```
