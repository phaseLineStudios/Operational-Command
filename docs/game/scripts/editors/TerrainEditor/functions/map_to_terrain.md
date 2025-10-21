# TerrainEditor::map_to_terrain Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 536–539)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func map_to_terrain(local_m: Vector2) -> Vector2
```

## Description

Wrapper for map_to_terrain from terrain renderer

## Source

```gdscript
func map_to_terrain(local_m: Vector2) -> Vector2:
	return terrain_render.map_to_terrain(local_m)
```
