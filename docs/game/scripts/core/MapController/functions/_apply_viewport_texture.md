# MapController::_apply_viewport_texture Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 217–227)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _apply_viewport_texture() -> void
```

## Description

Assign the terrain viewport as the map texture

## Source

```gdscript
func _apply_viewport_texture() -> void:
	if terrain_viewport == null:
		return
	# Temporarily use viewport texture directly
	_set_map_texture(terrain_viewport.get_texture())
	# Optional: Create an ImageTexture that will hold baked mipmaps (expensive path).
	if bake_viewport_mipmaps and _mipmap_texture == null:
		_mipmap_texture = ImageTexture.new()
	# Don't generate mipmaps yet - wait for render_ready signal
```
