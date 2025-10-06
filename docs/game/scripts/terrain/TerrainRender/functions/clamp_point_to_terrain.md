# TerrainRender::clamp_point_to_terrain Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 252–258)</br>
*Belongs to:* [TerrainRender](../TerrainRender.md)

**Signature**

```gdscript
func clamp_point_to_terrain(p: Vector2) -> Vector2
```

## Description

Clamp a single point to the terrain (local map coordinates)

## Source

```gdscript
func clamp_point_to_terrain(p: Vector2) -> Vector2:
	var sz: Vector2 = get_terrain_size()
	return Vector2(
		clamp(p.x, 0.0, sz.x - terrain_border_px * 2), clamp(p.y, 0.0, sz.y - terrain_border_px * 2)
	)
```
