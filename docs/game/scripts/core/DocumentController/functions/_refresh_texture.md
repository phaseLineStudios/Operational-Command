# DocumentController::_refresh_texture Function Reference

*Defined at:* `scripts/core/DocumentController.gd` (lines 522–551)</br>
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

	# Reduce glare so text stays readable under strong lights.
	material.albedo_color = Color.WHITE
	material.metallic = 0.0
	material.roughness = 1.0
	#material.specular = 0.0

	material.texture_filter = (
		BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
		if bake_viewport_mipmaps
		else BaseMaterial3D.TEXTURE_FILTER_LINEAR
	)

	if not bake_viewport_mipmaps:
		material.albedo_texture = viewport.get_texture()
		return

	var img := viewport.get_texture().get_image()
	if img == null:
		LogService.warning("Failed to get image from viewport", "DocumentController.gd")
		return

	img.generate_mipmaps()
	material.albedo_texture = ImageTexture.create_from_image(img)
```
