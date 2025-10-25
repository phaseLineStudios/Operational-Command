# MapController::_ready Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 29–57)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_plane = map.mesh as PlaneMesh
	var sx: float = abs(map.scale.x)
	if sx == 0.0:
		sx = 1.0
	var sz: float = abs(map.scale.z)
	if sz == 0.0:
		sz = 1.0
	_start_world_max = Vector2(_plane.size.x * sx, _plane.size.y * sz)

	_mat = map.get_active_material(0)
	_mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR
	_apply_viewport_texture()

	if not terrain_viewport.is_connected(
		"size_changed", Callable(self, "_on_viewport_size_changed")
	):
		terrain_viewport.connect("size_changed", Callable(self, "_on_viewport_size_changed"))

	if renderer:
		if not renderer.is_connected("map_resize", Callable(self, "_on_renderer_map_resize")):
			renderer.connect("map_resize", Callable(self, "_on_renderer_map_resize"))
		if not renderer.is_connected("resized", Callable(self, "_on_renderer_map_resize")):
			renderer.connect("resized", Callable(self, "_on_renderer_map_resize"))

	_update_viewport_to_renderer()
	_update_mesh_fit()
```
