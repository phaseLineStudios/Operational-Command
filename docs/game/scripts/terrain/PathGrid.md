# PathGrid Class Reference

*File:* `scripts/terrain/PathGrid.gd`
*Class name:* `PathGrid`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name PathGrid
extends Node
```

## Brief

Grid weights + A* over TerrainData.

## Detailed Description

Builds per-profile movement costs from surfaces + slope.

Cell size in meters (pathfinding resolution).

Allow diagonal movement.

Extra preference for road-like brushes (<1 = prefer).

If a brush multiplier for profile == 0 -> cell blocked.

Multiplier per 1.0 grade (rise/run). E.g. 0.5 -> +50% cost at 100% grade.

Cells with grade >= this are blocked (e.g. cliff). 1.0 = 100% grade = 45°.

Radius (m) around line features that applies line brush multipliers.

Enable developer drawing from an external CanvasItem

Cell alpha for overlay

Draw thin cell borders

Clamp max heat color to this weight (for contrast)

Estimate travel time (seconds) along path for unit base speed and profile

## Public Member Functions

- [`func _ready() -> void`](PathGrid/functions/_ready.md)
- [`func _exit_tree() -> void`](PathGrid/functions/_exit_tree.md)
- [`func astar_setup_defaults() -> void`](PathGrid/functions/astar_setup_defaults.md)
- [`func _bind_terrain_signals() -> void`](PathGrid/functions/_bind_terrain_signals.md)
- [`func rebuild(profile: int) -> void`](PathGrid/functions/rebuild.md) — Build/rebuild grid for a movement profile
- [`func _thread_build(snap: Dictionary) -> void`](PathGrid/functions/_thread_build.md) — Internal: worker function (runs off the main thread)
- [`func rebuild_async_cancel() -> void`](PathGrid/functions/rebuild_async_cancel.md) — Cancel an ongoing async build (best-effort)
- [`func _thread_finish(result: Variant, err: String) -> void`](PathGrid/functions/_thread_finish.md) — Create A* on main thread, cache it, swap in, and emit signals.
- [`func find_path_m(start_m: Vector2, goal_m: Vector2) -> PackedVector2Array`](PathGrid/functions/find_path_m.md) — Find a path (meters) for a profile.
- [`func _astar_key(profile: int) -> String`](PathGrid/functions/_astar_key.md) — Create a stable cache key for A* instances (includes everything that changes weights)
- [`func _raster_key(kind: String) -> String`](PathGrid/functions/_raster_key.md) — Keys for intermediate rasters (don’t include profile so they can be reused)
- [`func world_to_cell(p_m: Vector2) -> Vector2i`](PathGrid/functions/world_to_cell.md) — Convert world meters -> grid cell.
- [`func cell_to_world_center_m(c: Vector2i) -> Vector2`](PathGrid/functions/cell_to_world_center_m.md) — Convert grid cell -> world meters (cell center).
- [`func _weight_for_cell(cx: int, cy: int, profile: int, _r_solid: bool) -> float`](PathGrid/functions/_weight_for_cell.md)
- [`func _prepare_slope_cache() -> void`](PathGrid/functions/_prepare_slope_cache.md) — Build or reuse the slope “multiplier” raster (profile-agnostic)
- [`func _prepare_line_dist_cache() -> void`](PathGrid/functions/_prepare_line_dist_cache.md) — distance-to-nearest-line cache (profile-agnostic)
- [`func _surface_multiplier_at(p_m: Vector2, profile: int) -> float`](PathGrid/functions/_surface_multiplier_at.md)
- [`func _line_px_to_meters(width_px: float) -> float`](PathGrid/functions/_line_px_to_meters.md)
- [`func _line_multiplier_at(p_m: Vector2, profile: int) -> float`](PathGrid/functions/_line_multiplier_at.md)
- [`func _road_bias_at(p_m: Vector2) -> float`](PathGrid/functions/_road_bias_at.md)
- [`func _slope_multiplier_at_cell(cx: int, cy: int) -> float`](PathGrid/functions/_slope_multiplier_at_cell.md)
- [`func _collect_features() -> void`](PathGrid/functions/_collect_features.md)
- [`func _to_cell(p_m: Vector2) -> Vector2i`](PathGrid/functions/_to_cell.md)
- [`func _cell_center_m(c: Vector2i) -> Vector2`](PathGrid/functions/_cell_center_m.md)
- [`func _in_bounds(c: Vector2i) -> bool`](PathGrid/functions/_in_bounds.md)
- [`func _elev_m_at(p_m: Vector2) -> float`](PathGrid/functions/_elev_m_at.md)
- [`func debug_cell_from_world(p_m: Vector2) -> Vector2i`](PathGrid/functions/debug_cell_from_world.md) — Return grid cell for world meters.
- [`func debug_world_from_cell(c: Vector2i) -> Vector2`](PathGrid/functions/debug_world_from_cell.md) — Return cell center in meters.
- [`func debug_weight_at_cell(c: Vector2i) -> float`](PathGrid/functions/debug_weight_at_cell.md) — Weight at cell (or INF if OOB/solid).
- [`func debug_is_solid_cell(c: Vector2i) -> bool`](PathGrid/functions/debug_is_solid_cell.md) — True if solid.
- [`func debug_slope_mult_cell(c: Vector2i) -> float`](PathGrid/functions/debug_slope_mult_cell.md) — Slope multiplier at cell (uses cache if present).
- [`func debug_line_dist_cell(c: Vector2i) -> float`](PathGrid/functions/debug_line_dist_cell.md) — Distance to nearest line at cell (uses cache if present; INF if none).
- [`func debug_draw_overlay(ci: CanvasItem) -> void`](PathGrid/functions/debug_draw_overlay.md) — Render a grid overlay onto a CanvasItem (e.g., a Control).
- [`func _call_main(method: String, a0: Variant = null, a1: Variant = null) -> void`](PathGrid/functions/_call_main.md)
- [`func _emit_build_started(profile: int) -> void`](PathGrid/functions/_emit_build_started.md)
- [`func _emit_build_progress(p: float) -> void`](PathGrid/functions/_emit_build_progress.md)
- [`func _emit_grid_rebuilt() -> void`](PathGrid/functions/_emit_grid_rebuilt.md)
- [`func _emit_build_ready(profile: int) -> void`](PathGrid/functions/_emit_build_ready.md)
- [`func _emit_build_failed(reason: String) -> void`](PathGrid/functions/_emit_build_failed.md)
- [`func _closed_no_dup(pts: PackedVector2Array) -> PackedVector2Array`](PathGrid/functions/_closed_no_dup.md)
- [`func _poly_bounds(poly: PackedVector2Array) -> Rect2`](PathGrid/functions/_poly_bounds.md)
- [`func _polyline_bounds(pts: PackedVector2Array) -> Rect2`](PathGrid/functions/_polyline_bounds.md)
- [`func _dist_point_polyline(p: Vector2, pts: PackedVector2Array) -> float`](PathGrid/functions/_dist_point_polyline.md)
- [`func mix(a: float, b: float, t: float) -> float`](PathGrid/functions/mix.md)

## Public Attributes

- `TerrainData data` — Terrain source.
- `TerrainBrush.MoveProfile debug_profile` — Movement profile
- `DebugLayer debug_layer` — Which layer to draw
- `Array _area_features`
- `Array _line_features`
- `Dictionary _astar_cache`
- `Dictionary _slope_cache`
- `Dictionary _line_dist_cache`
- `Thread _build_thread`
- `float v`

## Signals

- `signal grid_rebuilt` — Emitted when the grid is rebuilt.
- `signal build_started(profile: int)` — Emits when an async build starts.
- `signal build_progress(p: float)` — Emits progress (0..1).
- `signal build_ready(profile: int)` — Emits when a fresh grid is ready (and installed).
- `signal build_failed(reason: String)` — Emits on failure/cancel.

## Enumerations

- `enum DebugLayer` — What to visualize.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _exit_tree

```gdscript
func _exit_tree() -> void
```

### astar_setup_defaults

```gdscript
func astar_setup_defaults() -> void
```

### _bind_terrain_signals

```gdscript
func _bind_terrain_signals() -> void
```

### rebuild

```gdscript
func rebuild(profile: int) -> void
```

Build/rebuild grid for a movement profile

### _thread_build

```gdscript
func _thread_build(snap: Dictionary) -> void
```

Internal: worker function (runs off the main thread)

### rebuild_async_cancel

```gdscript
func rebuild_async_cancel() -> void
```

Cancel an ongoing async build (best-effort)

### _thread_finish

```gdscript
func _thread_finish(result: Variant, err: String) -> void
```

Create A* on main thread, cache it, swap in, and emit signals.

### find_path_m

```gdscript
func find_path_m(start_m: Vector2, goal_m: Vector2) -> PackedVector2Array
```

Find a path (meters) for a profile. Returns PackedVector2Array world positions (m)

### _astar_key

```gdscript
func _astar_key(profile: int) -> String
```

Create a stable cache key for A* instances (includes everything that changes weights)

### _raster_key

```gdscript
func _raster_key(kind: String) -> String
```

Keys for intermediate rasters (don’t include profile so they can be reused)

### world_to_cell

```gdscript
func world_to_cell(p_m: Vector2) -> Vector2i
```

Convert world meters -> grid cell.

### cell_to_world_center_m

```gdscript
func cell_to_world_center_m(c: Vector2i) -> Vector2
```

Convert grid cell -> world meters (cell center).

### _weight_for_cell

```gdscript
func _weight_for_cell(cx: int, cy: int, profile: int, _r_solid: bool) -> float
```

### _prepare_slope_cache

```gdscript
func _prepare_slope_cache() -> void
```

Build or reuse the slope “multiplier” raster (profile-agnostic)

### _prepare_line_dist_cache

```gdscript
func _prepare_line_dist_cache() -> void
```

distance-to-nearest-line cache (profile-agnostic)

### _surface_multiplier_at

```gdscript
func _surface_multiplier_at(p_m: Vector2, profile: int) -> float
```

### _line_px_to_meters

```gdscript
func _line_px_to_meters(width_px: float) -> float
```

### _line_multiplier_at

```gdscript
func _line_multiplier_at(p_m: Vector2, profile: int) -> float
```

### _road_bias_at

```gdscript
func _road_bias_at(p_m: Vector2) -> float
```

### _slope_multiplier_at_cell

```gdscript
func _slope_multiplier_at_cell(cx: int, cy: int) -> float
```

### _collect_features

```gdscript
func _collect_features() -> void
```

### _to_cell

```gdscript
func _to_cell(p_m: Vector2) -> Vector2i
```

### _cell_center_m

```gdscript
func _cell_center_m(c: Vector2i) -> Vector2
```

### _in_bounds

```gdscript
func _in_bounds(c: Vector2i) -> bool
```

### _elev_m_at

```gdscript
func _elev_m_at(p_m: Vector2) -> float
```

### debug_cell_from_world

```gdscript
func debug_cell_from_world(p_m: Vector2) -> Vector2i
```

Return grid cell for world meters.

### debug_world_from_cell

```gdscript
func debug_world_from_cell(c: Vector2i) -> Vector2
```

Return cell center in meters.

### debug_weight_at_cell

```gdscript
func debug_weight_at_cell(c: Vector2i) -> float
```

Weight at cell (or INF if OOB/solid).

### debug_is_solid_cell

```gdscript
func debug_is_solid_cell(c: Vector2i) -> bool
```

True if solid.

### debug_slope_mult_cell

```gdscript
func debug_slope_mult_cell(c: Vector2i) -> float
```

Slope multiplier at cell (uses cache if present).

### debug_line_dist_cell

```gdscript
func debug_line_dist_cell(c: Vector2i) -> float
```

Distance to nearest line at cell (uses cache if present; INF if none).

### debug_draw_overlay

```gdscript
func debug_draw_overlay(ci: CanvasItem) -> void
```

Render a grid overlay onto a CanvasItem (e.g., a Control). Coordinates are meters.

### _call_main

```gdscript
func _call_main(method: String, a0: Variant = null, a1: Variant = null) -> void
```

### _emit_build_started

```gdscript
func _emit_build_started(profile: int) -> void
```

### _emit_build_progress

```gdscript
func _emit_build_progress(p: float) -> void
```

### _emit_grid_rebuilt

```gdscript
func _emit_grid_rebuilt() -> void
```

### _emit_build_ready

```gdscript
func _emit_build_ready(profile: int) -> void
```

### _emit_build_failed

```gdscript
func _emit_build_failed(reason: String) -> void
```

### _closed_no_dup

```gdscript
func _closed_no_dup(pts: PackedVector2Array) -> PackedVector2Array
```

### _poly_bounds

```gdscript
func _poly_bounds(poly: PackedVector2Array) -> Rect2
```

### _polyline_bounds

```gdscript
func _polyline_bounds(pts: PackedVector2Array) -> Rect2
```

### _dist_point_polyline

```gdscript
func _dist_point_polyline(p: Vector2, pts: PackedVector2Array) -> float
```

### mix

```gdscript
func mix(a: float, b: float, t: float) -> float
```

## Member Data Documentation

### data

```gdscript
var data: TerrainData
```

Decorators: `@export`

Terrain source.

### debug_profile

```gdscript
var debug_profile: TerrainBrush.MoveProfile
```

Decorators: `@export`

Movement profile

### debug_layer

```gdscript
var debug_layer: DebugLayer
```

Decorators: `@export`

Which layer to draw

### _area_features

```gdscript
var _area_features: Array
```

### _line_features

```gdscript
var _line_features: Array
```

### _astar_cache

```gdscript
var _astar_cache: Dictionary
```

### _slope_cache

```gdscript
var _slope_cache: Dictionary
```

### _line_dist_cache

```gdscript
var _line_dist_cache: Dictionary
```

### _build_thread

```gdscript
var _build_thread: Thread
```

### v

```gdscript
var v: float
```

## Signal Documentation

### grid_rebuilt

```gdscript
signal grid_rebuilt
```

Emitted when the grid is rebuilt.

### build_started

```gdscript
signal build_started(profile: int)
```

Emits when an async build starts.

### build_progress

```gdscript
signal build_progress(p: float)
```

Emits progress (0..1).

### build_ready

```gdscript
signal build_ready(profile: int)
```

Emits when a fresh grid is ready (and installed).

### build_failed

```gdscript
signal build_failed(reason: String)
```

Emits on failure/cancel.

## Enumeration Type Documentation

### DebugLayer

```gdscript
enum DebugLayer
```

What to visualize.
