# TerrainRender::is_inside_terrain Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 421–431)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func is_inside_terrain(pos: Vector2) -> bool
```

## Description

API to check if position is inside terrain

## Source

```gdscript
func is_inside_terrain(pos: Vector2) -> bool:
	if data == null:
		return false
	# Manually calculate terrain bounds based on margins
	# Terrain starts at (margin_left_px, margin_top_px) and extends by terrain size
	var terrain_rect := Rect2(
		Vector2(margin_left_px, margin_top_px), Vector2(data.width_m, data.height_m)
	)
	return terrain_rect.has_point(pos)
```
