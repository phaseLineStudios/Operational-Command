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
- [`func _apply_viewport_texture() -> void`](MapController/functions/_apply_viewport_texture.md) — Assign the terrain viewport as the map texture
- [`func _update_viewport_to_renderer() -> void`](MapController/functions/_update_viewport_to_renderer.md) — Resize the Viewport to match the renderer's pixel size (including margins)
- [`func _update_mesh_fit() -> void`](MapController/functions/_update_mesh_fit.md) — Fit PlaneMesh to the viewport aspect ratio, clamped to _start_world_max
- [`func _on_viewport_size_changed() -> void`](MapController/functions/_on_viewport_size_changed.md) — Viewport callback: refit plane on texture size change
- [`func _on_renderer_map_resize() -> void`](MapController/functions/_on_renderer_map_resize.md) — Renderer callback: sync viewport to new map pixel size
- [`func screen_to_map_and_terrain(screen_pos: Vector2) -> Variant`](MapController/functions/screen_to_map_and_terrain.md) — Helper: from screen pos to map pixels & terrain meters.
- [`func _raycast_to_map_plane(screen_pos: Vector2) -> Variant`](MapController/functions/_raycast_to_map_plane.md) — World-space hit on the plane under a screen position; null if none
- [`func _plane_hit_to_map_px(hit_world: Vector3) -> Variant`](MapController/functions/_plane_hit_to_map_px.md) — Convert a world hit on the plane to map pixels (0..viewport size)
- [`func _update_mouse_grid_ui() -> void`](MapController/functions/_update_mouse_grid_ui.md) — Grid hover label update
- [`func terrain_to_screen(terrain_pos: Vector2) -> Variant`](MapController/functions/terrain_to_screen.md) — Convert terrain position (meters) to screen position.
- [`func refresh() -> void`](MapController/functions/refresh.md) — Force-refresh the texture and refit

## Public Attributes

- `Vector2 grid_label_offset` — Pixel offset from the mouse to place the label
- `int viewport_oversample` — Render the TerrainViewport at N× resolution for anti-aliasing (1=off)
- `Vector2 _start_world_max`
- `StandardMaterial3D _mat`
- `PlaneMesh _plane`
- `Camera3D _camera`
- `ScenarioData _scenario`
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

### _apply_viewport_texture

```gdscript
func _apply_viewport_texture() -> void
```

Assign the terrain viewport as the map texture

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

Render the TerrainViewport at N× resolution for anti-aliasing (1=off)

### _start_world_max

```gdscript
var _start_world_max: Vector2
```

### _mat

```gdscript
var _mat: StandardMaterial3D
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
