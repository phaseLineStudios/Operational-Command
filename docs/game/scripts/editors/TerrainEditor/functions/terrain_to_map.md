# TerrainEditor::terrain_to_map Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 541–542)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func terrain_to_map(pos: Vector2) -> Vector2
```

## Description

Wrapper for terrain_to_map from terrain renderer

## Source

```gdscript
func terrain_to_map(pos: Vector2) -> Vector2:
	return terrain_render.terrain_to_map(pos)
```
