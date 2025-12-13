# MapController::_apply_viewport_texture Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 128–136)</br>
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
	# Temporarily use viewport texture directly
	_mat.albedo_texture = terrain_viewport.get_texture()
	# Create an ImageTexture that will hold mipmaps
	if _mipmap_texture == null:
		_mipmap_texture = ImageTexture.new()
	# Don't generate mipmaps yet - wait for render_ready signal
```
