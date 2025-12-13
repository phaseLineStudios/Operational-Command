# MapController::_ready Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 31–79)</br>
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
	# Use anisotropic filtering for better quality at extreme angles
	_mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	# Disable texture repeat to avoid edge artifacts
	_mat.uv1_triplanar = false

	# Enable automatic updates
	terrain_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS

	# Enable 2X MSAA for line smoothing without too much blur
	terrain_viewport.msaa_2d = Viewport.MSAA_2X
	# Disable screen space AA to keep text sharp
	terrain_viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED

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
		if not renderer.is_connected("render_ready", Callable(self, "_on_renderer_ready")):
			renderer.connect("render_ready", Callable(self, "_on_renderer_ready"))
		# Update mipmaps when renderer redraws (only when terrain changes)
		if (
			renderer.data
			and not renderer.data.is_connected("changed", Callable(self, "_on_terrain_changed"))
		):
			renderer.data.changed.connect(_on_terrain_changed, CONNECT_DEFERRED)

	_update_viewport_to_renderer()
	_update_mesh_fit()
```
