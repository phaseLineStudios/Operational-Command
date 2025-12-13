# TimerController::_setup_debug_draw Function Reference

*Defined at:* `scripts/core/TimerController.gd` (lines 351–366)</br>
*Belongs to:* [TimerController](../../TimerController.md)

**Signature**

```gdscript
func _setup_debug_draw(static_body: StaticBody3D) -> void
```

## Description

Setup debug visualization of collision box.

## Source

```gdscript
func _setup_debug_draw(static_body: StaticBody3D) -> void:
	_debug_mesh = MeshInstance3D.new()
	var box_mesh := BoxMesh.new()
	box_mesh.size = collision_box_size
	_debug_mesh.mesh = box_mesh

	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.0, 1.0, 0.0, 0.3)
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	_debug_mesh.material_override = material

	_debug_mesh.position = collision_box_position
	static_body.add_child(_debug_mesh)
```
