# MapController::_update_mipmap_texture Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 229–255)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _update_mipmap_texture() -> void
```

## Description

Update the mipmap texture from the viewport

## Source

```gdscript
func _update_mipmap_texture() -> void:
	if not bake_viewport_mipmaps:
		return
	if _mipmap_texture == null:
		_mipmap_texture = ImageTexture.new()

	# Get the viewport's rendered image
	var img := terrain_viewport.get_texture().get_image()
	if img == null or img.is_empty():
		return

	# Generate mipmaps for the image
	img.generate_mipmaps()

	# Update the texture (this replaces the texture data while keeping the same reference)
	if (
		_mipmap_texture.get_width() != img.get_width()
		or _mipmap_texture.get_height() != img.get_height()
	):
		_mipmap_texture.set_image(img)
	else:
		_mipmap_texture.update(img)

	# Switch material to use mipmap texture now that we have content
	_set_map_texture(_mipmap_texture)
```
