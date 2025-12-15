# MapController Class Reference

*File:* `scripts/core/MapController.gd`
*Class name:* `MapController`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name MapController
extends Node
```

## Brief

Handles map interaction and applies terrain renderer as a texture

## Public Member Functions

- [`func _ready() -> void`](MapController/functions/_ready.md)
- [`func init_terrain(scenario: ScenarioData) -> void`](MapController/functions/init_terrain.md) — Initilizes terrain for scenario
- [`func prebuild_force_profiles() -> void`](MapController/functions/prebuild_force_profiles.md) — Prebuild movement profiles
- [`func _process(_dt: float) -> void`](MapController/functions/_process.md)
- [`func _unhandled_input(event: InputEvent) -> void`](MapController/functions/_unhandled_input.md) — Handle *unhandled* input and emit when it hits the map.
- [`func _on_map_read_overlay_closed() -> void`](MapController/functions/_on_map_read_overlay_closed.md)
- [`func _set_read_mode(enabled: bool) -> void`](MapController/functions/_set_read_mode.md)
- [`func _apply_map_material_settings() -> void`](MapController/functions/_apply_map_material_settings.md)
- [`func _set_map_texture(tex: Texture2D) -> void`](MapController/functions/_set_map_texture.md)
- [`func _apply_viewport_texture() -> void`](MapController/functions/_apply_viewport_texture.md) — Assign the terrain viewport as the map texture
- [`func _update_mipmap_texture() -> void`](MapController/functions/_update_mipmap_texture.md) — Update the mipmap texture from the viewport
- [`func _is_dynamic_viewport() -> bool`](MapController/functions/_is_dynamic_viewport.md) — Returns true if the TerrainViewport should update every frame.
- [`func _sync_viewport_update_mode() -> void`](MapController/functions/_sync_viewport_update_mode.md) — Apply the correct SubViewport update mode for current settings.
- [`func _queue_viewport_update() -> void`](MapController/functions/_queue_viewport_update.md) — Schedule a one-shot render of the TerrainViewport (coalesced).
- [`func _do_viewport_update_once() -> void`](MapController/functions/_do_viewport_update_once.md)
- [`func _schedule_mipmap_update() -> void`](MapController/functions/_schedule_mipmap_update.md) — Debounce mipmap rebuilds and ensure the map gets baked back to a static ImageTexture.
- [`func _on_mipmap_timer_timeout() -> void`](MapController/functions/_on_mipmap_timer_timeout.md)
- [`func _run_mipmap_update_async(gen: int) -> void`](MapController/functions/_run_mipmap_update_async.md)
- [`func _bind_terrain_signals(d: TerrainData) -> void`](MapController/functions/_bind_terrain_signals.md) — Bind/unbind TerrainData signals so map refresh works in UPDATE_DISABLED mode.
- [`func _request_map_refresh(with_mipmaps: bool) -> void`](MapController/functions/_request_map_refresh.md) — Request a one-shot viewport render and (optionally) a mipmap bake.
- [`func _on_terrain_elevation_changed(_rect: Rect2i) -> void`](MapController/functions/_on_terrain_elevation_changed.md)
- [`func _on_terrain_content_changed(_kind: String, _ids: PackedInt32Array) -> void`](MapController/functions/_on_terrain_content_changed.md)
- [`func _update_viewport_to_renderer() -> void`](MapController/functions/_update_viewport_to_renderer.md) — Resize the Viewport to match the renderer's pixel size (including margins)
- [`func _update_mesh_fit() -> void`](MapController/functions/_update_mesh_fit.md) — Fit PlaneMesh to the viewport aspect ratio, clamped to _start_world_max
- [`func _on_viewport_size_changed() -> void`](MapController/functions/_on_viewport_size_changed.md) — Viewport callback: refit plane on texture size change
- [`func _on_renderer_map_resize() -> void`](MapController/functions/_on_renderer_map_resize.md) — Renderer callback: sync viewport to new map pixel size
- [`func _on_terrain_changed() -> void`](MapController/functions/_on_terrain_changed.md) — Terrain data changed callback: update mipmaps when terrain changes
- [`func _on_renderer_ready() -> void`](MapController/functions/_on_renderer_ready.md) — Renderer ready callback: generate mipmaps after initial render completes
- [`func screen_to_map_and_terrain(screen_pos: Vector2) -> Variant`](MapController/functions/screen_to_map_and_terrain.md) — Helper: from screen pos to map pixels & terrain meters.
- [`func _raycast_to_map_plane(screen_pos: Vector2) -> Variant`](MapController/functions/_raycast_to_map_plane.md) — World-space hit on the plane under a screen position; null if none
- [`func _plane_hit_to_map_px(hit_world: Vector3) -> Variant`](MapController/functions/_plane_hit_to_map_px.md) — Convert a world hit on the plane to map pixels (0..viewport size)
- [`func _update_mouse_grid_ui() -> void`](MapController/functions/_update_mouse_grid_ui.md) — Grid hover label update
- [`func terrain_to_screen(terrain_pos: Vector2) -> Variant`](MapController/functions/terrain_to_screen.md) — Convert terrain position (meters) to screen position.
- [`func refresh() -> void`](MapController/functions/refresh.md) — Force-refresh the texture and refit

## Public Attributes

- `Vector2 grid_label_offset` — Pixel offset from the mouse to place the label
- `int viewport_oversample` — Base oversample for the TerrainViewport (1=off).
- `Vector2i viewport_max_size_px` — Maximum TerrainViewport render target size (pixels).
- `bool viewport_update_always` — If true, the terrain SubViewport renders every frame (useful for debug/animated overlays).
- `bool bake_viewport_mipmaps` — If true, bake a CPU ImageTexture with mipmaps from the viewport.
- `float mipmap_update_delay_sec` — Delay before rebuilding mipmaps after a map change (seconds).
- `float map_brightness` — Multiplies the map texture color (lower = darker).
- `float map_contrast` — Contrast curve around mid-gray (1.0 = unchanged).
- `float map_sharpen_strength` — Lightweight sharpen in shader (0 = off).
- `bool map_unshaded` — If true, add self-lit contribution to keep the map readable under dark lighting.
- `Vector2 _start_world_max`
- `ShaderMaterial _map_mat`
- `PlaneMesh _plane`
- `Camera3D _camera`
- `ScenarioData _scenario`
- `ImageTexture _mipmap_texture`
- `TerrainData _terrain_data`
- `SceneTreeTimer _mipmap_timer`
- `float _viewport_pixel_scale`
- `Vector2 _last_mouse_pos`
- `ViewportReadOverlay _map_read_overlay`
- `SubViewport terrain_viewport`
- `TerrainRender renderer`
- `MeshInstance3D map`
- `PanelContainer _grid_label`

## Signals

- `signal map_resized(new_world_size: Vector2)` — Emitted after the mesh has been resized (world XZ)
- `signal mouse_grid_changed(terrain_pos: Vector2, grid: String)` — Emitted when mouse is over the map, with terrain position and grid string
- `signal map_unhandled_mouse(event, map_pos: Vector2, terrain_pos: Vector2)` — Emitted on unhandled mouse input that hits the map

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### init_terrain

```gdscript
func init_terrain(scenario: ScenarioData) -> void
```

Initilizes terrain for scenario

### prebuild_force_profiles

```gdscript
func prebuild_force_profiles() -> void
```

Prebuild movement profiles

### _process

```gdscript
func _process(_dt: float) -> void
```

### _unhandled_input

```gdscript
func _unhandled_input(event: InputEvent) -> void
```

Handle *unhandled* input and emit when it hits the map.

### _on_map_read_overlay_closed

```gdscript
func _on_map_read_overlay_closed() -> void
```

### _set_read_mode

```gdscript
func _set_read_mode(enabled: bool) -> void
```

### _apply_map_material_settings

```gdscript
func _apply_map_material_settings() -> void
```

### _set_map_texture

```gdscript
func _set_map_texture(tex: Texture2D) -> void
```

### _apply_viewport_texture

```gdscript
func _apply_viewport_texture() -> void
```

Assign the terrain viewport as the map texture

### _update_mipmap_texture

```gdscript
func _update_mipmap_texture() -> void
```

Update the mipmap texture from the viewport

### _is_dynamic_viewport

```gdscript
func _is_dynamic_viewport() -> bool
```

Returns true if the TerrainViewport should update every frame.

### _sync_viewport_update_mode

```gdscript
func _sync_viewport_update_mode() -> void
```

Apply the correct SubViewport update mode for current settings.

### _queue_viewport_update

```gdscript
func _queue_viewport_update() -> void
```

Schedule a one-shot render of the TerrainViewport (coalesced).

### _do_viewport_update_once

```gdscript
func _do_viewport_update_once() -> void
```

### _schedule_mipmap_update

```gdscript
func _schedule_mipmap_update() -> void
```

Debounce mipmap rebuilds and ensure the map gets baked back to a static ImageTexture.

### _on_mipmap_timer_timeout

```gdscript
func _on_mipmap_timer_timeout() -> void
```

### _run_mipmap_update_async

```gdscript
func _run_mipmap_update_async(gen: int) -> void
```

### _bind_terrain_signals

```gdscript
func _bind_terrain_signals(d: TerrainData) -> void
```

Bind/unbind TerrainData signals so map refresh works in UPDATE_DISABLED mode.

### _request_map_refresh

```gdscript
func _request_map_refresh(with_mipmaps: bool) -> void
```

Request a one-shot viewport render and (optionally) a mipmap bake.

### _on_terrain_elevation_changed

```gdscript
func _on_terrain_elevation_changed(_rect: Rect2i) -> void
```

### _on_terrain_content_changed

```gdscript
func _on_terrain_content_changed(_kind: String, _ids: PackedInt32Array) -> void
```

### _update_viewport_to_renderer

```gdscript
func _update_viewport_to_renderer() -> void
```

Resize the Viewport to match the renderer's pixel size (including margins)

### _update_mesh_fit

```gdscript
func _update_mesh_fit() -> void
```

Fit PlaneMesh to the viewport aspect ratio, clamped to _start_world_max

### _on_viewport_size_changed

```gdscript
func _on_viewport_size_changed() -> void
```

Viewport callback: refit plane on texture size change

### _on_renderer_map_resize

```gdscript
func _on_renderer_map_resize() -> void
```

Renderer callback: sync viewport to new map pixel size

### _on_terrain_changed

```gdscript
func _on_terrain_changed() -> void
```

Terrain data changed callback: update mipmaps when terrain changes

### _on_renderer_ready

```gdscript
func _on_renderer_ready() -> void
```

Renderer ready callback: generate mipmaps after initial render completes

### screen_to_map_and_terrain

```gdscript
func screen_to_map_and_terrain(screen_pos: Vector2) -> Variant
```

Helper: from screen pos to map pixels & terrain meters. Returns null if not on map

### _raycast_to_map_plane

```gdscript
func _raycast_to_map_plane(screen_pos: Vector2) -> Variant
```

World-space hit on the plane under a screen position; null if none

### _plane_hit_to_map_px

```gdscript
func _plane_hit_to_map_px(hit_world: Vector3) -> Variant
```

Convert a world hit on the plane to map pixels (0..viewport size)

### _update_mouse_grid_ui

```gdscript
func _update_mouse_grid_ui() -> void
```

Grid hover label update

### terrain_to_screen

```gdscript
func terrain_to_screen(terrain_pos: Vector2) -> Variant
```

Convert terrain position (meters) to screen position. Returns null if not visible
`terrain_pos` Position in terrain meters
[return] Screen position as Vector2, or null if position is not visible

### refresh

```gdscript
func refresh() -> void
```

Force-refresh the texture and refit

## Member Data Documentation

### grid_label_offset

```gdscript
var grid_label_offset: Vector2
```

Decorators: `@export`

Pixel offset from the mouse to place the label

### viewport_oversample

```gdscript
var viewport_oversample: int
```

Decorators: `@export`

Base oversample for the TerrainViewport (1=off). May be reduced to respect max size.

### viewport_max_size_px

```gdscript
var viewport_max_size_px: Vector2i
```

Decorators: `@export`

Maximum TerrainViewport render target size (pixels).
Prevents huge map textures on large terrains.

### viewport_update_always

```gdscript
var viewport_update_always: bool
```

Decorators: `@export`

If true, the terrain SubViewport renders every frame (useful for debug/animated overlays).

### bake_viewport_mipmaps

```gdscript
var bake_viewport_mipmaps: bool
```

Decorators: `@export`

If true, bake a CPU ImageTexture with mipmaps from the viewport.
Improves oblique-angle sharpness (expensive).

### mipmap_update_delay_sec

```gdscript
var mipmap_update_delay_sec: float
```

Decorators: `@export`

Delay before rebuilding mipmaps after a map change (seconds).

### map_brightness

```gdscript
var map_brightness: float
```

Decorators: `@export_range(0.6, 1.0, 0.01)`

Multiplies the map texture color (lower = darker).

### map_contrast

```gdscript
var map_contrast: float
```

Decorators: `@export_range(0.8, 1.3, 0.01)`

Contrast curve around mid-gray (1.0 = unchanged).

### map_sharpen_strength

```gdscript
var map_sharpen_strength: float
```

Decorators: `@export_range(0.0, 2.0, 0.01)`

Lightweight sharpen in shader (0 = off).

### map_unshaded

```gdscript
var map_unshaded: bool
```

Decorators: `@export`

If true, add self-lit contribution to keep the map readable under dark lighting.

### _start_world_max

```gdscript
var _start_world_max: Vector2
```

### _map_mat

```gdscript
var _map_mat: ShaderMaterial
```

### _plane

```gdscript
var _plane: PlaneMesh
```

### _camera

```gdscript
var _camera: Camera3D
```

### _scenario

```gdscript
var _scenario: ScenarioData
```

### _mipmap_texture

```gdscript
var _mipmap_texture: ImageTexture
```

### _terrain_data

```gdscript
var _terrain_data: TerrainData
```

### _mipmap_timer

```gdscript
var _mipmap_timer: SceneTreeTimer
```

### _viewport_pixel_scale

```gdscript
var _viewport_pixel_scale: float
```

### _last_mouse_pos

```gdscript
var _last_mouse_pos: Vector2
```

### _map_read_overlay

```gdscript
var _map_read_overlay: ViewportReadOverlay
```

### terrain_viewport

```gdscript
var terrain_viewport: SubViewport
```

### renderer

```gdscript
var renderer: TerrainRender
```

### map

```gdscript
var map: MeshInstance3D
```

### _grid_label

```gdscript
var _grid_label: PanelContainer
```

## Signal Documentation

### map_resized

```gdscript
signal map_resized(new_world_size: Vector2)
```

Emitted after the mesh has been resized (world XZ)

### mouse_grid_changed

```gdscript
signal mouse_grid_changed(terrain_pos: Vector2, grid: String)
```

Emitted when mouse is over the map, with terrain position and grid string

### map_unhandled_mouse

```gdscript
signal map_unhandled_mouse(event, map_pos: Vector2, terrain_pos: Vector2)
```

Emitted on unhandled mouse input that hits the map
