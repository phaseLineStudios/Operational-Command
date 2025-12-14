class_name MapController
extends Node
## Handles map interaction and applies terrain renderer as a texture

const READ_OVERLAY_SCENE := preload("res://scenes/ui/viewport_read_overlay.tscn")
const MAP_PAPER_SHADER := preload("res://assets/shaders/MapPaper.gdshader")

## Emitted after the mesh has been resized (world XZ)
signal map_resized(new_world_size: Vector2)
## Emitted when mouse is over the map, with terrain position and grid string
signal mouse_grid_changed(terrain_pos: Vector2, grid: String)
## Emitted on unhandled mouse input that hits the map
signal map_unhandled_mouse(event, map_pos: Vector2, terrain_pos: Vector2)

## Pixel offset from the mouse to place the label
@export var grid_label_offset: Vector2 = Vector2(16, 16)
## Base oversample for the TerrainViewport (1=off). May be reduced to respect max size.
@export var viewport_oversample: int = 6
## Maximum TerrainViewport render target size (pixels). Prevents huge map textures on large terrains.
@export var viewport_max_size_px: Vector2i = Vector2i(8192, 8192)
## If true, the terrain SubViewport renders every frame (useful for debug/animated overlays).
@export var viewport_update_always: bool = false
## If true, bake a CPU ImageTexture with mipmaps from the viewport (improves oblique-angle sharpness).
@export var bake_viewport_mipmaps: bool = true
## Delay before rebuilding mipmaps after a map change (seconds).
@export var mipmap_update_delay_sec: float = 0.25

@export_group("Readability")
## Multiplies the map texture color (lower = darker).
@export_range(0.6, 1.0, 0.01) var map_brightness: float = 0.88
## Contrast curve around mid-gray (1.0 = unchanged).
@export_range(0.8, 1.3, 0.01) var map_contrast: float = 1.06
## Lightweight sharpen in shader (0 = off).
@export_range(0.0, 2.0, 0.01) var map_sharpen_strength: float = 0.65
## If true, add self-lit contribution to keep the map readable under dark lighting.
@export var map_unshaded: bool = false

var _start_world_max: Vector2
var _map_mat: ShaderMaterial
var _plane: PlaneMesh
var _camera: Camera3D
var _scenario: ScenarioData
var _mipmap_texture: ImageTexture
var _terrain_data: TerrainData
var _viewport_update_queued := false
var _mipmap_timer: SceneTreeTimer
var _mipmap_gen := 0
var _dynamic_viewport_cached := false
var _viewport_pixel_scale: float = 1.0  # Viewport pixels per renderer "map unit"
var _last_mouse_pos: Vector2 = Vector2(-9999, -9999)  # Track last mouse position
var _map_read_overlay: ViewportReadOverlay = null

@onready var terrain_viewport: SubViewport = %TerrainViewport
@onready var renderer: TerrainRender = %TerrainRender
@onready var map: MeshInstance3D = %Map
@onready var _grid_label: PanelContainer = $GridUI


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


## Initilizes terrain for scenario
func init_terrain(scenario: ScenarioData) -> void:
	_scenario = scenario
	if _scenario.terrain != null:
		renderer.data = _scenario.terrain
	_bind_terrain_signals(renderer.data)
	_request_map_refresh(true)

	prebuild_force_profiles()


## Prebuild movement profiles
func prebuild_force_profiles() -> void:
	if renderer == null:
		return

	var scen := Game.current_scenario
	if scen == null:
		return

	var all_units: Array[ScenarioUnit] = []
	all_units.append_array(scen.units)
	all_units.append_array(scen.playable_units)
	var wanted := {}
	for su in all_units:
		wanted[su.unit.movement_profile] = true
	for p in wanted.keys():
		renderer.path_grid.rebuild(p)


func _process(_dt: float) -> void:
	var dyn := _is_dynamic_viewport()
	if dyn != _dynamic_viewport_cached:
		_dynamic_viewport_cached = dyn
		_sync_viewport_update_mode()
		if not dyn:
			_request_map_refresh(true)
	var current_mouse := get_viewport().get_mouse_position()
	if current_mouse.distance_to(_last_mouse_pos) < 1.0:
		return
	_last_mouse_pos = current_mouse
	_update_mouse_grid_ui()


## Handle *unhandled* input and emit when it hits the map.
func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventMouse):
		return
	var mouse := (event as InputEventMouse).position
	var res: Variant = screen_to_map_and_terrain(mouse)
	if res == null:
		return
	if (
		event is InputEventMouseButton
		and (event as InputEventMouseButton).pressed
		and (event as InputEventMouseButton).double_click
		and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT
	):
		_open_map_read_overlay()
		get_viewport().set_input_as_handled()
		return
	emit_signal("map_unhandled_mouse", event, res.map_px, res.terrain)


func _open_map_read_overlay() -> void:
	if terrain_viewport == null:
		return
	if _map_read_overlay != null and is_instance_valid(_map_read_overlay):
		return
	var inst := READ_OVERLAY_SCENE.instantiate() as ViewportReadOverlay
	if inst == null:
		return
	inst.consume_escape = true
	_map_read_overlay = inst
	_map_read_overlay.closed.connect(_on_map_read_overlay_closed, CONNECT_ONE_SHOT)
	get_tree().root.add_child(_map_read_overlay)
	_map_read_overlay.open_texture(terrain_viewport.get_texture(), "Map")
	_set_read_mode(true)


func _on_map_read_overlay_closed() -> void:
	_map_read_overlay = null
	_set_read_mode(false)


func _set_read_mode(enabled: bool) -> void:
	var pp := get_tree().root.find_child("PostProcess", true, false)
	if pp != null and pp.has_method("set"):
		if "read_mode_enabled" in pp:
			pp.read_mode_enabled = enabled


func _apply_map_material_settings() -> void:
	if _map_mat == null:
		return
	_map_mat.set_shader_parameter("brightness", clampf(map_brightness, 0.0, 1.0))
	_map_mat.set_shader_parameter("contrast", maxf(map_contrast, 0.0))
	_map_mat.set_shader_parameter("sharpen_strength", maxf(map_sharpen_strength, 0.0))
	_map_mat.set_shader_parameter("unshaded", 1.0 if map_unshaded else 0.0)


func _set_map_texture(tex: Texture2D) -> void:
	if _map_mat == null:
		return
	_map_mat.set_shader_parameter("map_tex", tex)


## Assign the terrain viewport as the map texture
func _apply_viewport_texture() -> void:
	if terrain_viewport == null:
		return
	# Temporarily use viewport texture directly
	_set_map_texture(terrain_viewport.get_texture())
	# Optional: Create an ImageTexture that will hold baked mipmaps (expensive path).
	if bake_viewport_mipmaps and _mipmap_texture == null:
		_mipmap_texture = ImageTexture.new()
	# Don't generate mipmaps yet - wait for render_ready signal


## Update the mipmap texture from the viewport
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


## Returns true if the TerrainViewport should update every frame.
func _is_dynamic_viewport() -> bool:
	if viewport_update_always:
		return true
	if renderer == null:
		return false
	var dbg := renderer.get_node_or_null("DebugOverlay")
	if dbg != null and "debug_enabled" in dbg:
		return bool(dbg.debug_enabled)
	return false


## Apply the correct SubViewport update mode for current settings.
func _sync_viewport_update_mode() -> void:
	if terrain_viewport == null:
		return
	if _is_dynamic_viewport():
		terrain_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		_apply_viewport_texture()
		return
	terrain_viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED


## Schedule a one-shot render of the TerrainViewport (coalesced).
func _queue_viewport_update() -> void:
	if _viewport_update_queued or terrain_viewport == null:
		return
	_viewport_update_queued = true
	call_deferred("_do_viewport_update_once")


func _do_viewport_update_once() -> void:
	_viewport_update_queued = false
	if terrain_viewport == null or _is_dynamic_viewport():
		return
	terrain_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE


## Debounce mipmap rebuilds and ensure the map gets baked back to a static ImageTexture.
func _schedule_mipmap_update() -> void:
	if not bake_viewport_mipmaps:
		return
	if _is_dynamic_viewport() or not is_inside_tree():
		return
	_mipmap_gen += 1
	if _mipmap_timer != null:
		return
	var delay_sec: float = mipmap_update_delay_sec
	if delay_sec < 0.0:
		delay_sec = 0.0
	_mipmap_timer = get_tree().create_timer(delay_sec)
	_mipmap_timer.timeout.connect(_on_mipmap_timer_timeout)


func _on_mipmap_timer_timeout() -> void:
	_mipmap_timer = null
	_run_mipmap_update_async(_mipmap_gen)


func _run_mipmap_update_async(gen: int) -> void:
	if _is_dynamic_viewport() or terrain_viewport == null or not is_inside_tree():
		return

	terrain_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	await get_tree().process_frame
	await get_tree().process_frame

	if gen != _mipmap_gen:
		return
	_update_mipmap_texture()


## Bind/unbind TerrainData signals so map refresh works in UPDATE_DISABLED mode.
func _bind_terrain_signals(d: TerrainData) -> void:
	if _terrain_data == d:
		return

	if _terrain_data:
		if _terrain_data.is_connected("changed", Callable(self, "_on_terrain_changed")):
			_terrain_data.disconnect("changed", Callable(self, "_on_terrain_changed"))
		if _terrain_data.is_connected("elevation_changed", Callable(self, "_on_terrain_elevation_changed")):
			_terrain_data.disconnect(
				"elevation_changed", Callable(self, "_on_terrain_elevation_changed")
			)
		if _terrain_data.is_connected("surfaces_changed", Callable(self, "_on_terrain_content_changed")):
			_terrain_data.disconnect(
				"surfaces_changed", Callable(self, "_on_terrain_content_changed")
			)
		if _terrain_data.is_connected("lines_changed", Callable(self, "_on_terrain_content_changed")):
			_terrain_data.disconnect("lines_changed", Callable(self, "_on_terrain_content_changed"))
		if _terrain_data.is_connected("points_changed", Callable(self, "_on_terrain_content_changed")):
			_terrain_data.disconnect("points_changed", Callable(self, "_on_terrain_content_changed"))
		if _terrain_data.is_connected("labels_changed", Callable(self, "_on_terrain_content_changed")):
			_terrain_data.disconnect("labels_changed", Callable(self, "_on_terrain_content_changed"))

	_terrain_data = d
	if _terrain_data == null:
		return

	_terrain_data.changed.connect(_on_terrain_changed, CONNECT_DEFERRED)
	_terrain_data.elevation_changed.connect(_on_terrain_elevation_changed, CONNECT_DEFERRED)
	_terrain_data.surfaces_changed.connect(_on_terrain_content_changed, CONNECT_DEFERRED)
	_terrain_data.lines_changed.connect(_on_terrain_content_changed, CONNECT_DEFERRED)
	_terrain_data.points_changed.connect(_on_terrain_content_changed, CONNECT_DEFERRED)
	_terrain_data.labels_changed.connect(_on_terrain_content_changed, CONNECT_DEFERRED)


## Request a one-shot viewport render and (optionally) a mipmap bake.
func _request_map_refresh(with_mipmaps: bool) -> void:
	if terrain_viewport == null or not is_inside_tree():
		return
	_sync_viewport_update_mode()
	if _is_dynamic_viewport():
		return

	# Show the live viewport immediately; bake mipmaps after changes settle.
	_apply_viewport_texture()
	_queue_viewport_update()
	if with_mipmaps and bake_viewport_mipmaps:
		_schedule_mipmap_update()


func _on_terrain_elevation_changed(_rect: Rect2i) -> void:
	_request_map_refresh(true)


func _on_terrain_content_changed(_kind: String, _ids: PackedInt32Array) -> void:
	_request_map_refresh(true)


## Resize the Viewport to match the renderer's pixel size (including margins)
func _update_viewport_to_renderer() -> void:
	if renderer == null:
		return
	var logical := renderer.size
	var logical_w: int = max(1, int(ceil(logical.x)))
	var logical_h: int = max(1, int(ceil(logical.y)))

	var os: int = max(viewport_oversample, 1)
	var chosen_scale: float = float(os)

	if viewport_max_size_px.x > 0 and viewport_max_size_px.y > 0:
		var max_scale_x: float = float(viewport_max_size_px.x) / float(logical_w)
		var max_scale_y: float = float(viewport_max_size_px.y) / float(logical_h)
		var max_scale: float = minf(max_scale_x, max_scale_y)
		if max_scale >= 1.0:
			# Prefer integer scaling to keep text crisp (avoids fractional canvas scaling blur).
			var max_int_scale: int = maxi(1, int(floor(max_scale)))
			var chosen_int: int = mini(os, max_int_scale)
			chosen_scale = float(chosen_int)
		else:
			# Too large to fit even at scale=1; downscale (fractional is unavoidable).
			chosen_scale = max_scale

	_viewport_pixel_scale = chosen_scale
	if _viewport_pixel_scale <= 0.0:
		_viewport_pixel_scale = 1.0

	var new_size := Vector2i(
		maxi(1, int(round(float(logical_w) * _viewport_pixel_scale))),
		maxi(1, int(round(float(logical_h) * _viewport_pixel_scale)))
	)
	if terrain_viewport.size != new_size:
		terrain_viewport.size = new_size

	# Scale the 2D canvas to match the chosen render target resolution.
	terrain_viewport.canvas_transform = Transform2D.IDENTITY.scaled(
		Vector2(_viewport_pixel_scale, _viewport_pixel_scale)
	)


## Fit PlaneMesh to the viewport aspect ratio, clamped to _start_world_max
func _update_mesh_fit() -> void:
	var tex_size := Vector2(terrain_viewport.size)
	if tex_size.x <= 0.0 or tex_size.y <= 0.0:
		return

	var target_r := tex_size.x / tex_size.y
	var max_w := _start_world_max.x
	var max_h := _start_world_max.y

	var fit_w := max_w
	var fit_h := fit_w / target_r
	if fit_h > max_h:
		fit_h = max_h
		fit_w = fit_h * target_r

	var sx: float = abs(map.scale.x)
	if sx == 0.0:
		sx = 1.0
	var sz: float = abs(map.scale.z)
	if sz == 0.0:
		sz = 1.0
	_plane.size = Vector2(fit_w / sx, fit_h / sz)
	map.mesh = _plane

	emit_signal("map_resized", Vector2(fit_w, fit_h))


## Viewport callback: refit plane on texture size change
func _on_viewport_size_changed() -> void:
	_apply_viewport_texture()
	_update_mesh_fit()
	_request_map_refresh(true)


## Renderer callback: sync viewport to new map pixel size
func _on_renderer_map_resize() -> void:
	_update_viewport_to_renderer()


## Terrain data changed callback: update mipmaps when terrain changes
func _on_terrain_changed() -> void:
	_request_map_refresh(true)


## Renderer ready callback: generate mipmaps after initial render completes
func _on_renderer_ready() -> void:
	_request_map_refresh(true)


## Helper: from screen pos to map pixels & terrain meters. Returns null if not on map
func screen_to_map_and_terrain(screen_pos: Vector2) -> Variant:
	var hit: Variant = _raycast_to_map_plane(screen_pos)
	if hit == null:
		return null
	var map_px: Variant = _plane_hit_to_map_px(hit)
	if map_px == null or renderer == null:
		return null
	var s: float = _viewport_pixel_scale if _viewport_pixel_scale > 0.0 else float(max(viewport_oversample, 1))
	var logical_px: Vector2 = map_px / s
	var terrain_pos: Vector2 = renderer.map_to_terrain(logical_px)
	return {"map_px": map_px, "terrain": terrain_pos}


## World-space hit on the plane under a screen position; null if none
func _raycast_to_map_plane(screen_pos: Vector2) -> Variant:
	if _camera == null:
		_camera = get_viewport().get_camera_3d()
	if _camera == null or map == null or map.mesh == null:
		return null
	var ray_from := _camera.project_ray_origin(screen_pos)
	var ray_dir := _camera.project_ray_normal(screen_pos)
	if ray_dir == Vector3.ZERO:
		return null
	var plane_normal := map.global_transform.basis.y
	if plane_normal.length() <= 0.0001:
		return null
	var plane := Plane(plane_normal.normalized(), map.global_transform.origin)
	return plane.intersects_ray(ray_from, ray_dir)


## Convert a world hit on the plane to map pixels (0..viewport size)
func _plane_hit_to_map_px(hit_world: Vector3) -> Variant:
	if map == null or _plane == null:
		return null
	var local := map.to_local(hit_world)
	var half_w := _plane.size.x * 0.5
	var half_h := _plane.size.y * 0.5
	if abs(local.x) > half_w or abs(local.z) > half_h:
		return null
	var u := (local.x / (_plane.size.x)) + 0.5
	var v := (local.z / (_plane.size.y)) + 0.5
	var vp := terrain_viewport.size
	return Vector2(clamp(u, 0.0, 1.0) * vp.x, clamp(v, 0.0, 1.0) * vp.y)


## Grid hover label update
func _update_mouse_grid_ui() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_HIDDEN:
		_grid_label.visible = false
		return
	var mouse := get_viewport().get_mouse_position()
	var res: Variant = screen_to_map_and_terrain(mouse)
	if res == null:
		if _grid_label:
			_grid_label.visible = false
		return
	var grid: String = renderer.pos_to_grid(res.terrain)
	emit_signal("mouse_grid_changed", res.terrain, grid)
	if _grid_label:
		_grid_label.get_node("Label").text = grid
		_grid_label.global_position = mouse + grid_label_offset
		_grid_label.visible = true


## Convert terrain position (meters) to screen position. Returns null if not visible
## [param terrain_pos] Position in terrain meters
## [return] Screen position as Vector2, or null if position is not visible
func terrain_to_screen(terrain_pos: Vector2) -> Variant:
	if renderer == null:
		return null

	# Convert terrain meters to map pixels
	var map_px: Vector2 = renderer.terrain_to_map(terrain_pos)

	# Convert map units to viewport pixels (oversample and/or downscale).
	var s: float = _viewport_pixel_scale if _viewport_pixel_scale > 0.0 else float(max(viewport_oversample, 1))
	var vp_px: Vector2 = map_px * s

	# Convert map pixels to UV coordinates (0-1)
	var vp := terrain_viewport.size
	if vp.x <= 0 or vp.y <= 0:
		return null
	var u := vp_px.x / vp.x
	var v := vp_px.y / vp.y

	# Convert UV to local plane coordinates
	if _plane == null:
		return null
	var local_x := (u - 0.5) * _plane.size.x
	var local_z := (v - 0.5) * _plane.size.y
	var local_pos := Vector3(local_x, 0.0, local_z)

	# Convert local to world coordinates
	if map == null:
		return null
	var world_pos := map.to_global(local_pos)

	# Project world position to screen
	if _camera == null:
		_camera = get_viewport().get_camera_3d()
	if _camera == null:
		return null

	# Check if position is behind camera
	var cam_to_pos := world_pos - _camera.global_position
	var forward := -_camera.global_transform.basis.z
	if cam_to_pos.dot(forward) <= 0.0:
		return null

	var screen_pos := _camera.unproject_position(world_pos)

	# Verify position is within viewport bounds
	var vp_size := get_viewport().get_visible_rect().size
	if (
		screen_pos.x < 0.0
		or screen_pos.y < 0.0
		or screen_pos.x > vp_size.x
		or screen_pos.y > vp_size.y
	):
		return null

	return screen_pos


## Force-refresh the texture and refit
func refresh() -> void:
	_apply_viewport_texture()
	_update_viewport_to_renderer()
	_update_mesh_fit()
	_request_map_refresh(true)
