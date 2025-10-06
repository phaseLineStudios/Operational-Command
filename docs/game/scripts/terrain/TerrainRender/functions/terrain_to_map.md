# TerrainRender::terrain_to_map Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 276–281)</br>
*Belongs to:* [TerrainRender](../TerrainRender.md)

**Signature**

```gdscript
func terrain_to_map(pos: Vector2) -> Vector2
```

## Description

helepr function to convert map position to terrain position

## Source

```gdscript
func terrain_to_map(pos: Vector2) -> Vector2:
	var map_margins := Vector2(margin_left_px, margin_top_px)
	var map_borders := Vector2(terrain_border_px, terrain_border_px)
	return pos + map_margins + map_borders
```
