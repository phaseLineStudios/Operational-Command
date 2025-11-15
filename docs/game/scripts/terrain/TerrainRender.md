# TerrainRender Class Reference

*File:* `scripts/terrain/TerrainRender.gd`
*Class name:* `TerrainRender`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name TerrainRender
extends Control
```

## Brief

Renders map: grid, margins, contours, surfaces, features, labels

Visual Style

If true, rebuild the grid automatically when data is set/changed.

## Public Member Functions

- [`func _ready()`](TerrainRender/functions/_ready.md)
- [`func _apply_base_style_if_needed() -> void`](TerrainRender/functions/_apply_base_style_if_needed.md) — Build base style
- [`func _set_data(d: TerrainData)`](TerrainRender/functions/_set_data.md) — Set new Terrain Data
- [`func _push_data_to_layers() -> void`](TerrainRender/functions/_push_data_to_layers.md) — Push exports to their respective layers
- [`func _on_data_changed() -> void`](TerrainRender/functions/_on_data_changed.md) — Reconfigure if terrain data is changed
- [`func render_error(error: String = "") -> void`](TerrainRender/functions/render_error.md) — Show a render error
- [`func clear_render_error() -> void`](TerrainRender/functions/clear_render_error.md) — Hide the render error
- [`func _mark_all_dirty() -> void`](TerrainRender/functions/_mark_all_dirty.md) — Mark elements as dirty to redraw
- [`func _debounce_relayout_and_push() -> void`](TerrainRender/functions/_debounce_relayout_and_push.md) — Debounce the relayout and push styles
- [`func _draw_map_size() -> void`](TerrainRender/functions/_draw_map_size.md) — Resize the map to fit the terrain data
- [`func _on_base_layer_resize()`](TerrainRender/functions/_on_base_layer_resize.md) — Emit a resize event for base layer
- [`func _rebuild_surface_spatial_index() -> void`](TerrainRender/functions/_rebuild_surface_spatial_index.md) — Build a spatial hash for polygon AREA surfaces.
- [`func clamp_point_to_terrain(p: Vector2) -> Vector2`](TerrainRender/functions/clamp_point_to_terrain.md) — Clamp a single point to the terrain (local map coordinates)
- [`func clamp_shape_to_terrain(pts: PackedVector2Array) -> PackedVector2Array`](TerrainRender/functions/clamp_shape_to_terrain.md) — Clamp an entire polygon (without mutating the source array)
- [`func map_to_terrain(local_m: Vector2) -> Vector2`](TerrainRender/functions/map_to_terrain.md) — Helper function to convert terrain position to map position
- [`func terrain_to_map(pos: Vector2) -> Vector2`](TerrainRender/functions/terrain_to_map.md) — helepr function to convert map position to terrain position
- [`func to_local(pos: Vector2) -> Vector2`](TerrainRender/functions/to_local.md)
- [`func is_inside_map(pos: Vector2) -> bool`](TerrainRender/functions/is_inside_map.md) — API to check if position is inside map
- [`func is_inside_terrain(pos: Vector2) -> bool`](TerrainRender/functions/is_inside_terrain.md) — API to check if position is inside terrain
- [`func pos_to_grid(pos: Vector2, total_digits: int = 6) -> String`](TerrainRender/functions/pos_to_grid.md) — API to get grid number from terrain local position
- [`func grid_to_pos(grid: String) -> Vector2`](TerrainRender/functions/grid_to_pos.md) — API to get terrain local position from grid number
- [`func get_terrain_size() -> Vector2`](TerrainRender/functions/get_terrain_size.md) — API to get the map size
- [`func get_terrain_position() -> Vector2`](TerrainRender/functions/get_terrain_position.md) — API to get the map position
- [`func get_surface_at_terrain_position(terrain_pos: Vector2) -> Dictionary`](TerrainRender/functions/get_surface_at_terrain_position.md) — Surface under a terrain-local position.
- [`func nav_find_path_m(start_m: Vector2, goal_m: Vector2) -> PackedVector2Array`](TerrainRender/functions/nav_find_path_m.md) — Request a path in terrain meters via attached PathGrid
- [`func nav_estimate_time_s(path_m: PackedVector2Array, base_speed_mps: float, profile: int) -> float`](TerrainRender/functions/nav_estimate_time_s.md) — Estimate travel time (seconds) along a path for a given base speed and profile

## Public Attributes

- `TerrainData: data` — Terrain Data
- `Color base_color` — Base background map color
- `Color terrain_border_color` — Color of the map border
- `int terrain_border_px` — Width of the map border
- `int title_size` — Font size for map title
- `Color margin_color` — Color of outer margin
- `int margin_top_px` — Size of outer margin top
- `int margin_bottom_px` — Size of outer margin bottom
- `int margin_left_px` — Size of outer margin left
- `int margin_right_px` — Size of outer margin right
- `Color label_color` — Color for text
- `Font label_font` — Font for text
- `int label_size` — Font size of grid number text
- `Color grid_100m_color` — Color of grid lines for every 100m
- `Color grid_1km_color` — Color of grid lines for every 1000m
- `float grid_line_px` — Width of grid lines for every 100m
- `float grid_1km_line_px` — Width of grid lines for every 1000m
- `Color contour_color` — Base contour color
- `Color contour_thick_color` — Contour color for thick lines
- `float contour_px` — Base width for contour lines
- `int contour_thick_every_m` — How often should contour lines be thick (in m)
- `int smooth_iterations` — Smoothing iterations
- `float smooth_segment_len_m` — Smoothing segment lengths
- `bool smooth_keep_ends` — Should smoothing keep ends
- `int contour_label_every_m` — Contour label spacing
- `bool contour_label_on_thick_only` — Only show elevation label on thick contours
- `Color contour_label_color` — Contour label color
- `Color contour_label_bg` — Contour label background
- `float contour_label_padding_px` — Contour label padding
- `Font contour_label_font` — Contour label font
- `int contour_label_size` — Contour label font size
- `float contour_label_gap_extra_px` — Extra space beyond plaque width
- `PathGrid path_grid` — reference to the PathGrid used for movement/pathfinding.
- `int nav_default_profile` — Default profile to rebuild for when auto-building.
- `int surface_index_cell_m` — Cell size (m) for surface spatial index grid.
- `StyleBoxFlat _base_sb`
- `SceneTreeTimer _debounce_timer`
- `Dictionary _surface_index`
- `Array _surface_meta`
- `PanelContainer margin`
- `PanelContainer base_layer`
- `SurfaceLayer surface_layer`
- `LineLayer line_layer`
- `PointLayer point_layer`
- `ContourLayer contour_layer`
- `GridLayer grid_layer`
- `LabelLayer label_layer`
- `StampLayer stamp_layer`
- `CenterContainer error_layer`
- `Label error_label`

## Public Constants

- `const GRID_SIZE_M` — Grid cell size in meters

## Signals

- `signal map_resize` — Emits when the map is resized

## Member Function Documentation

### _ready

```gdscript
func _ready()
```

### _apply_base_style_if_needed

```gdscript
func _apply_base_style_if_needed() -> void
```

Build base style

### _set_data

```gdscript
func _set_data(d: TerrainData)
```

Set new Terrain Data

### _push_data_to_layers

```gdscript
func _push_data_to_layers() -> void
```

Push exports to their respective layers

### _on_data_changed

```gdscript
func _on_data_changed() -> void
```

Reconfigure if terrain data is changed

### render_error

```gdscript
func render_error(error: String = "") -> void
```

Show a render error

### clear_render_error

```gdscript
func clear_render_error() -> void
```

Hide the render error

### _mark_all_dirty

```gdscript
func _mark_all_dirty() -> void
```

Mark elements as dirty to redraw

### _debounce_relayout_and_push

```gdscript
func _debounce_relayout_and_push() -> void
```

Debounce the relayout and push styles

### _draw_map_size

```gdscript
func _draw_map_size() -> void
```

Resize the map to fit the terrain data

### _on_base_layer_resize

```gdscript
func _on_base_layer_resize()
```

Emit a resize event for base layer

### _rebuild_surface_spatial_index

```gdscript
func _rebuild_surface_spatial_index() -> void
```

Build a spatial hash for polygon AREA surfaces.

### clamp_point_to_terrain

```gdscript
func clamp_point_to_terrain(p: Vector2) -> Vector2
```

Clamp a single point to the terrain (local map coordinates)

### clamp_shape_to_terrain

```gdscript
func clamp_shape_to_terrain(pts: PackedVector2Array) -> PackedVector2Array
```

Clamp an entire polygon (without mutating the source array)

### map_to_terrain

```gdscript
func map_to_terrain(local_m: Vector2) -> Vector2
```

Helper function to convert terrain position to map position

### terrain_to_map

```gdscript
func terrain_to_map(pos: Vector2) -> Vector2
```

helepr function to convert map position to terrain position

### to_local

```gdscript
func to_local(pos: Vector2) -> Vector2
```

### is_inside_map

```gdscript
func is_inside_map(pos: Vector2) -> bool
```

API to check if position is inside map

### is_inside_terrain

```gdscript
func is_inside_terrain(pos: Vector2) -> bool
```

API to check if position is inside terrain

### pos_to_grid

```gdscript
func pos_to_grid(pos: Vector2, total_digits: int = 6) -> String
```

API to get grid number from terrain local position

### grid_to_pos

```gdscript
func grid_to_pos(grid: String) -> Vector2
```

API to get terrain local position from grid number

### get_terrain_size

```gdscript
func get_terrain_size() -> Vector2
```

API to get the map size

### get_terrain_position

```gdscript
func get_terrain_position() -> Vector2
```

API to get the map position

### get_surface_at_terrain_position

```gdscript
func get_surface_at_terrain_position(terrain_pos: Vector2) -> Dictionary
```

Surface under a terrain-local position.
Returns the topmost polygon AREA surface dict or {}.

### nav_find_path_m

```gdscript
func nav_find_path_m(start_m: Vector2, goal_m: Vector2) -> PackedVector2Array
```

Request a path in terrain meters via attached PathGrid

### nav_estimate_time_s

```gdscript
func nav_estimate_time_s(path_m: PackedVector2Array, base_speed_mps: float, profile: int) -> float
```

Estimate travel time (seconds) along a path for a given base speed and profile

## Member Data Documentation

### data

```gdscript
var data: TerrainData:
```

Decorators: `@export`

Terrain Data

### base_color

```gdscript
var base_color: Color
```

Decorators: `@export`

Base background map color

### terrain_border_color

```gdscript
var terrain_border_color: Color
```

Decorators: `@export`

Color of the map border

### terrain_border_px

```gdscript
var terrain_border_px: int
```

Decorators: `@export`

Width of the map border

### title_size

```gdscript
var title_size: int
```

Decorators: `@export`

Font size for map title

### margin_color

```gdscript
var margin_color: Color
```

Decorators: `@export`

Color of outer margin

### margin_top_px

```gdscript
var margin_top_px: int
```

Decorators: `@export`

Size of outer margin top

### margin_bottom_px

```gdscript
var margin_bottom_px: int
```

Decorators: `@export`

Size of outer margin bottom

### margin_left_px

```gdscript
var margin_left_px: int
```

Decorators: `@export`

Size of outer margin left

### margin_right_px

```gdscript
var margin_right_px: int
```

Decorators: `@export`

Size of outer margin right

### label_color

```gdscript
var label_color: Color
```

Decorators: `@export`

Color for text

### label_font

```gdscript
var label_font: Font
```

Decorators: `@export`

Font for text

### label_size

```gdscript
var label_size: int
```

Decorators: `@export`

Font size of grid number text

### grid_100m_color

```gdscript
var grid_100m_color: Color
```

Decorators: `@export`

Color of grid lines for every 100m

### grid_1km_color

```gdscript
var grid_1km_color: Color
```

Decorators: `@export`

Color of grid lines for every 1000m

### grid_line_px

```gdscript
var grid_line_px: float
```

Decorators: `@export`

Width of grid lines for every 100m

### grid_1km_line_px

```gdscript
var grid_1km_line_px: float
```

Decorators: `@export`

Width of grid lines for every 1000m

### contour_color

```gdscript
var contour_color: Color
```

Decorators: `@export`

Base contour color

### contour_thick_color

```gdscript
var contour_thick_color: Color
```

Decorators: `@export`

Contour color for thick lines

### contour_px

```gdscript
var contour_px: float
```

Decorators: `@export`

Base width for contour lines

### contour_thick_every_m

```gdscript
var contour_thick_every_m: int
```

Decorators: `@export`

How often should contour lines be thick (in m)

### smooth_iterations

```gdscript
var smooth_iterations: int
```

Decorators: `@export`

Smoothing iterations

### smooth_segment_len_m

```gdscript
var smooth_segment_len_m: float
```

Decorators: `@export`

Smoothing segment lengths

### smooth_keep_ends

```gdscript
var smooth_keep_ends: bool
```

Decorators: `@export`

Should smoothing keep ends

### contour_label_every_m

```gdscript
var contour_label_every_m: int
```

Decorators: `@export`

Contour label spacing

### contour_label_on_thick_only

```gdscript
var contour_label_on_thick_only: bool
```

Decorators: `@export`

Only show elevation label on thick contours

### contour_label_color

```gdscript
var contour_label_color: Color
```

Decorators: `@export`

Contour label color

### contour_label_bg

```gdscript
var contour_label_bg: Color
```

Decorators: `@export`

Contour label background

### contour_label_padding_px

```gdscript
var contour_label_padding_px: float
```

Decorators: `@export`

Contour label padding

### contour_label_font

```gdscript
var contour_label_font: Font
```

Decorators: `@export`

Contour label font

### contour_label_size

```gdscript
var contour_label_size: int
```

Decorators: `@export`

Contour label font size

### contour_label_gap_extra_px

```gdscript
var contour_label_gap_extra_px: float
```

Decorators: `@export`

Extra space beyond plaque width

### path_grid

```gdscript
var path_grid: PathGrid
```

Decorators: `@export`

reference to the PathGrid used for movement/pathfinding.

### nav_default_profile

```gdscript
var nav_default_profile: int
```

Decorators: `@export`

Default profile to rebuild for when auto-building.

### surface_index_cell_m

```gdscript
var surface_index_cell_m: int
```

Decorators: `@export`

Cell size (m) for surface spatial index grid.

### _base_sb

```gdscript
var _base_sb: StyleBoxFlat
```

### _debounce_timer

```gdscript
var _debounce_timer: SceneTreeTimer
```

### _surface_index

```gdscript
var _surface_index: Dictionary
```

### _surface_meta

```gdscript
var _surface_meta: Array
```

### margin

```gdscript
var margin: PanelContainer
```

### base_layer

```gdscript
var base_layer: PanelContainer
```

### surface_layer

```gdscript
var surface_layer: SurfaceLayer
```

### line_layer

```gdscript
var line_layer: LineLayer
```

### point_layer

```gdscript
var point_layer: PointLayer
```

### contour_layer

```gdscript
var contour_layer: ContourLayer
```

### grid_layer

```gdscript
var grid_layer: GridLayer
```

### label_layer

```gdscript
var label_layer: LabelLayer
```

### stamp_layer

```gdscript
var stamp_layer: StampLayer
```

### error_layer

```gdscript
var error_layer: CenterContainer
```

### error_label

```gdscript
var error_label: Label
```

## Constant Documentation

### GRID_SIZE_M

```gdscript
const GRID_SIZE_M
```

Grid cell size in meters

## Signal Documentation

### map_resize

```gdscript
signal map_resize
```

Emits when the map is resized
