# TerrainRender::map_to_terrain Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 269–274)</br>
*Belongs to:* [TerrainRender](../TerrainRender.md)

**Signature**

```gdscript
func map_to_terrain(local_m: Vector2) -> Vector2
```

## Description

Helper function to convert terrain position to map position

## Source

```gdscript
func map_to_terrain(local_m: Vector2) -> Vector2:
	var map_margins := Vector2(margin_left_px, margin_top_px)
	var map_borders := Vector2(terrain_border_px, terrain_border_px)
	return local_m - map_margins - map_borders
```
