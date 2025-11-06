# DrawingController::_init_drawing_mesh Function Reference

*Defined at:* `scripts/core/DrawingController.gd` (lines 41–68)</br>
*Belongs to:* [DrawingController](../../DrawingController.md)

**Signature**

```gdscript
func _init_drawing_mesh() -> void
```

## Source

```gdscript
func _init_drawing_mesh() -> void:
	if not map_mesh or not is_instance_valid(map_mesh):
		LogService.error("Cannot init drawing mesh: map_mesh invalid", "DrawingController")
		return

	# Check if DrawingMesh already exists
	var existing := map_mesh.get_node_or_null("DrawingMesh")
	if existing:
		return

	# Create a MeshInstance3D for rendering drawings
	var drawing_mesh := MeshInstance3D.new()
	drawing_mesh.name = "DrawingMesh"

	# Create an unshaded material that uses vertex colors
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	material.albedo_color = Color.WHITE
	material.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
	material.cull_mode = BaseMaterial3D.CULL_DISABLED  # Disable backface culling
	material.no_depth_test = false
	drawing_mesh.material_override = material
	drawing_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	map_mesh.add_child(drawing_mesh)
```
