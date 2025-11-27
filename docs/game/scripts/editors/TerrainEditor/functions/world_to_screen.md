# TerrainEditor::world_to_screen Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 493–496)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func world_to_screen(pos: Vector2) -> Vector2
```

## Description

API to get world position from screen position

## Source

```gdscript
func world_to_screen(pos: Vector2) -> Vector2:
	return (pos - camera.position) * camera.zoom + terrain_render.global_position
```
