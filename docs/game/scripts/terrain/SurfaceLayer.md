# SurfaceLayer Class Reference

*File:* `scripts/terrain/SurfaceLayer.gd`
*Class name:* `SurfaceLayer`
*Inherits:* `Control`
> **Experimental**

## Synopsis

```gdscript
class_name SurfaceLayer
extends Control
```

## Brief

Renders area surfaces (polygons) with per-id caching and minimal rebuilds.

## Detailed Description

Only recalculates groups affected by TerrainData.surfaces_changed.

Snap odd-pixel stroke widths by offsetting by half a pixel for crisper lines

## Public Member Functions

- [`func set_data(d: TerrainData) -> void`](SurfaceLayer/functions/set_data.md) — Assigns TerrainData, resets caches, wires signals, and schedules redraw
- [`func mark_dirty() -> void`](SurfaceLayer/functions/mark_dirty.md) — Marks the whole layer as dirty and queues a redraw (forces full rebuild)
- [`func _on_surfaces_changed(kind: String, ids: PackedInt32Array) -> void`](SurfaceLayer/functions/_on_surfaces_changed.md) — Handles TerrainData surface mutations and marks affected groups dirty
- [`func _draw() -> void`](SurfaceLayer/functions/_draw.md)
- [`func _rebuild_all_from_data() -> void`](SurfaceLayer/functions/_rebuild_all_from_data.md) — Full rebuild from TerrainData
- [`func _rebuild_dirty_groups() -> void`](SurfaceLayer/functions/_rebuild_dirty_groups.md) — Starts asynchronous unions for any groups currently marked dirty
- [`func _upsert_from_data(id: int, rebuild_old_key: bool) -> void`](SurfaceLayer/functions/_upsert_from_data.md) — Inserts/updates one surface from data, moving between groups if needed
- [`func _remove_id(id: int) -> void`](SurfaceLayer/functions/_remove_id.md) — Removes a surface by id and marks its group dirty
- [`func _refresh_geometry_same_group(id: int) -> void`](SurfaceLayer/functions/_refresh_geometry_same_group.md) — Refreshes geometry when points changed but the brush grouping stayed the same
- [`func _move_if_key_changed(id: int) -> void`](SurfaceLayer/functions/_move_if_key_changed.md) — Moves a surface between groups if its brush (draw recipe) changed
- [`func _ensure_group(key: String, brush: TerrainBrush) -> void`](SurfaceLayer/functions/_ensure_group.md) — Ensures a group record exists for the given brush key
- [`func _sorted_groups() -> Array`](SurfaceLayer/functions/_sorted_groups.md) — Returns groups sorted by z-index
- [`func _start_union_thread(key: String) -> void`](SurfaceLayer/functions/_start_union_thread.md) — Starts/queues a worker thread to compute AABB-filtered union for a group
- [`func _union_worker(key: String, polys: Array, bboxes: Array, ver: int) -> void`](SurfaceLayer/functions/_union_worker.md) — Worker entry, performs AABB clustering and unions the cluster polygons
- [`func _apply_union_result(key: String, merged: Array, ver: int) -> void`](SurfaceLayer/functions/_apply_union_result.md) — Applies a finished union result to the group if still up-to-date
- [`func _join_and_clear_thread(key: String) -> void`](SurfaceLayer/functions/_join_and_clear_thread.md) — Joins the worker thread for a group (if running) and clears it
- [`func _cancel_all_threads() -> void`](SurfaceLayer/functions/_cancel_all_threads.md) — Cancels and clears all worker threads and pending versions
- [`func _union_group_aabb(polys: Array, bboxes: Array) -> Array`](SurfaceLayer/functions/_union_group_aabb.md) — Unions polygons using connected AABB clusters to minimize pairwise merges
- [`func _union_group(polys: Array) -> Array`](SurfaceLayer/functions/_union_group.md) — Convenience passthrough to the non-AABB union implementation
- [`func _closed_copy(pts: PackedVector2Array, closed: bool) -> PackedVector2Array`](SurfaceLayer/functions/_closed_copy.md) — Returns a closed copy of a polyline (appends first point if needed)
- [`func _offset_half_px(pts: PackedVector2Array) -> PackedVector2Array`](SurfaceLayer/functions/_offset_half_px.md) — Offsets all points by (0.5, 0.5) to align odd-width strokes to pixel centers
- [`func _poly_bbox(pts: PackedVector2Array) -> Rect2`](SurfaceLayer/functions/_poly_bbox.md) — Computes axis-aligned bounding box for a polygon
- [`func _draw_polyline_closed(pts: PackedVector2Array, color: Color, width: float) -> void`](SurfaceLayer/functions/_draw_polyline_closed.md) — Draws a closed polyline with optional last segment if not already closed
- [`func _brush_key(brush: TerrainBrush) -> String`](SurfaceLayer/functions/_brush_key.md) — Builds a stable key string for grouping surfaces by brush/recipe
- [`func _union_polys(polys: Array) -> Array`](SurfaceLayer/functions/_union_polys.md) — Unions an array of polygons pairwise (fallback/slow path)
- [`func _sanitize_polygon(pts_in: PackedVector2Array) -> PackedVector2Array`](SurfaceLayer/functions/_sanitize_polygon.md) — Removes duplicate/adjacent points and optional duplicated closing vertex
- [`func _polygon_area(pts: PackedVector2Array) -> float`](SurfaceLayer/functions/_polygon_area.md) — Returns polygon signed area (positive for CCW)
- [`func _find_surface_by_id(id: int) -> Variant`](SurfaceLayer/functions/_find_surface_by_id.md) — Finds a surface dictionary in TerrainData by id
- [`func _build_draw_batches(sorted_groups: Array) -> Array`](SurfaceLayer/functions/_build_draw_batches.md) — Builds draw batches by merging consecutive groups with identical recipes
- [`func _rec_key(rec: Dictionary) -> String`](SurfaceLayer/functions/_rec_key.md) — Produces a stable batching key based on draw state (z/mode/colors/texture)

## Public Attributes

- `bool antialias` — Enable antialiasing for polylines and strokes
- `int max_pattern_size_px` — Maximum allowed pattern/texture size in pixels (for tiled symbol fills)
- `TerrainData data`
- `Dictionary _groups`
- `Dictionary _id_to_key`
- `Dictionary _tri_cache`
- `Dictionary _threads`
- `Dictionary _pending_ver`
- `TerrainRender renderer`

## Signals

- `signal batches_rebuilt` — Emitted when any group’s merged geometry was rebuilt (only dirty groups)

## Member Function Documentation

### set_data

```gdscript
func set_data(d: TerrainData) -> void
```

Assigns TerrainData, resets caches, wires signals, and schedules redraw

### mark_dirty

```gdscript
func mark_dirty() -> void
```

Marks the whole layer as dirty and queues a redraw (forces full rebuild)

### _on_surfaces_changed

```gdscript
func _on_surfaces_changed(kind: String, ids: PackedInt32Array) -> void
```

Handles TerrainData surface mutations and marks affected groups dirty

### _draw

```gdscript
func _draw() -> void
```

### _rebuild_all_from_data

```gdscript
func _rebuild_all_from_data() -> void
```

Full rebuild from TerrainData

### _rebuild_dirty_groups

```gdscript
func _rebuild_dirty_groups() -> void
```

Starts asynchronous unions for any groups currently marked dirty

### _upsert_from_data

```gdscript
func _upsert_from_data(id: int, rebuild_old_key: bool) -> void
```

Inserts/updates one surface from data, moving between groups if needed

### _remove_id

```gdscript
func _remove_id(id: int) -> void
```

Removes a surface by id and marks its group dirty

### _refresh_geometry_same_group

```gdscript
func _refresh_geometry_same_group(id: int) -> void
```

Refreshes geometry when points changed but the brush grouping stayed the same

### _move_if_key_changed

```gdscript
func _move_if_key_changed(id: int) -> void
```

Moves a surface between groups if its brush (draw recipe) changed

### _ensure_group

```gdscript
func _ensure_group(key: String, brush: TerrainBrush) -> void
```

Ensures a group record exists for the given brush key

### _sorted_groups

```gdscript
func _sorted_groups() -> Array
```

Returns groups sorted by z-index

### _start_union_thread

```gdscript
func _start_union_thread(key: String) -> void
```

Starts/queues a worker thread to compute AABB-filtered union for a group

### _union_worker

```gdscript
func _union_worker(key: String, polys: Array, bboxes: Array, ver: int) -> void
```

Worker entry, performs AABB clustering and unions the cluster polygons

### _apply_union_result

```gdscript
func _apply_union_result(key: String, merged: Array, ver: int) -> void
```

Applies a finished union result to the group if still up-to-date

### _join_and_clear_thread

```gdscript
func _join_and_clear_thread(key: String) -> void
```

Joins the worker thread for a group (if running) and clears it

### _cancel_all_threads

```gdscript
func _cancel_all_threads() -> void
```

Cancels and clears all worker threads and pending versions

### _union_group_aabb

```gdscript
func _union_group_aabb(polys: Array, bboxes: Array) -> Array
```

Unions polygons using connected AABB clusters to minimize pairwise merges

### _union_group

```gdscript
func _union_group(polys: Array) -> Array
```

Convenience passthrough to the non-AABB union implementation

### _closed_copy

```gdscript
func _closed_copy(pts: PackedVector2Array, closed: bool) -> PackedVector2Array
```

Returns a closed copy of a polyline (appends first point if needed)

### _offset_half_px

```gdscript
func _offset_half_px(pts: PackedVector2Array) -> PackedVector2Array
```

Offsets all points by (0.5, 0.5) to align odd-width strokes to pixel centers

### _poly_bbox

```gdscript
func _poly_bbox(pts: PackedVector2Array) -> Rect2
```

Computes axis-aligned bounding box for a polygon

### _draw_polyline_closed

```gdscript
func _draw_polyline_closed(pts: PackedVector2Array, color: Color, width: float) -> void
```

Draws a closed polyline with optional last segment if not already closed

### _brush_key

```gdscript
func _brush_key(brush: TerrainBrush) -> String
```

Builds a stable key string for grouping surfaces by brush/recipe

### _union_polys

```gdscript
func _union_polys(polys: Array) -> Array
```

Unions an array of polygons pairwise (fallback/slow path)

### _sanitize_polygon

```gdscript
func _sanitize_polygon(pts_in: PackedVector2Array) -> PackedVector2Array
```

Removes duplicate/adjacent points and optional duplicated closing vertex

### _polygon_area

```gdscript
func _polygon_area(pts: PackedVector2Array) -> float
```

Returns polygon signed area (positive for CCW)

### _find_surface_by_id

```gdscript
func _find_surface_by_id(id: int) -> Variant
```

Finds a surface dictionary in TerrainData by id

### _build_draw_batches

```gdscript
func _build_draw_batches(sorted_groups: Array) -> Array
```

Builds draw batches by merging consecutive groups with identical recipes

### _rec_key

```gdscript
func _rec_key(rec: Dictionary) -> String
```

Produces a stable batching key based on draw state (z/mode/colors/texture)

## Member Data Documentation

### antialias

```gdscript
var antialias: bool
```

Enable antialiasing for polylines and strokes

### max_pattern_size_px

```gdscript
var max_pattern_size_px: int
```

Maximum allowed pattern/texture size in pixels (for tiled symbol fills)

### data

```gdscript
var data: TerrainData
```

### _groups

```gdscript
var _groups: Dictionary
```

### _id_to_key

```gdscript
var _id_to_key: Dictionary
```

### _tri_cache

```gdscript
var _tri_cache: Dictionary
```

### _threads

```gdscript
var _threads: Dictionary
```

### _pending_ver

```gdscript
var _pending_ver: Dictionary
```

### renderer

```gdscript
var renderer: TerrainRender
```

## Signal Documentation

### batches_rebuilt

```gdscript
signal batches_rebuilt
```

Emitted when any group’s merged geometry was rebuilt (only dirty groups)
