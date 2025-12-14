# MapController::_ready Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 61–108)</br>
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

	_map_mat = ShaderMaterial.new()
	_map_mat.shader = MAP_PAPER_SHADER
	map.material_override = _map_mat
	_apply_map_material_settings()

	# Enable 4X MSAA for line smoothing without too much blur
	terrain_viewport.msaa_2d = Viewport.MSAA_4X
	# Disable screen space AA to keep text sharp
	terrain_viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
	# Pixel snap improves readability for thin lines/text.
	if "snap_2d_transforms_to_pixel" in terrain_viewport:
		terrain_viewport.set("snap_2d_transforms_to_pixel", true)
	if "snap_2d_vertices_to_pixel" in terrain_viewport:
		terrain_viewport.set("snap_2d_vertices_to_pixel", true)

	_apply_viewport_texture()
	_dynamic_viewport_cached = _is_dynamic_viewport()
	_sync_viewport_update_mode()

	if not terrain_viewport.is_connected(
		"size_changed", Callable(self, "_on_viewport_size_changed")
	):
		terrain_viewport.connect("size_changed", Callable(self, "_on_viewport_size_changed"))

	if renderer:
		if not renderer.is_connected("map_resize", Callable(self, "_on_renderer_map_resize")):
			renderer.connect("map_resize", Callable(self, "_on_renderer_map_resize"))
		if not renderer.is_connected("resized", Callable(self, "_on_renderer_map_resize")):
			renderer.connect("resized", Callable(self, "_on_renderer_map_resize"))
		if not renderer.is_connected("render_ready", Callable(self, "_on_renderer_ready")):
			renderer.connect("render_ready", Callable(self, "_on_renderer_ready"))
		_bind_terrain_signals(renderer.data)

	_update_viewport_to_renderer()
	_update_mesh_fit()
	_request_map_refresh(true)
```
