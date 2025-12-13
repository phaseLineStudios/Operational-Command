# TerrainEditor::screen_to_world Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 490–493)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func screen_to_world(pos: Vector2) -> Vector2
```

## Description

API to get screen position from world position

## Source

```gdscript
func screen_to_world(pos: Vector2) -> Vector2:
	return (pos - terrain_render.global_position) / camera.zoom + camera.position
```
