# DocumentController::_refresh_texture Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 479–492)</br>
*Belongs to:* [DocumentController](../../DocumentController.md)

**Signature**

```gdscript
func _refresh_texture(material: StandardMaterial3D, viewport: SubViewport) -> void
```

## Description

Refresh a material's texture from viewport with mipmaps

## Source

```gdscript
func _refresh_texture(material: StandardMaterial3D, viewport: SubViewport) -> void:
	if material == null or viewport == null:
		LogService.warning("Cannot refresh: material or viewport is null", "DocumentController.gd")
		return

	var img := viewport.get_texture().get_image()
	if img == null:
		LogService.warning("Failed to get image from viewport", "DocumentController.gd")
		return

	img.generate_mipmaps()
	material.albedo_texture = ImageTexture.create_from_image(img)
```
