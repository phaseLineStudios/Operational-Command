# MapController::_update_viewport_to_renderer Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 81–92)</br>
*Belongs to:* [MapController](../MapController.md)

**Signature**

```gdscript
func _update_viewport_to_renderer() -> void
```

## Description

Resize the Viewport to match the renderer's pixel size (including margins)

## Source

```gdscript
func _update_viewport_to_renderer() -> void:
	if renderer == null:
		return
	var os: int = max(viewport_oversample, 1)
	var logical := renderer.size
	var new_size := Vector2i(max(1, int(ceil(logical.x)) * os), max(1, int(ceil(logical.y)) * os))
	if terrain_viewport.size != new_size:
		terrain_viewport.size = new_size
		# Make the 2D canvas draw scaled up to fill the larger viewport:
		terrain_viewport.canvas_transform = Transform2D.IDENTITY.scaled(Vector2(os, os))
```
