# PointLayer Class Reference

*File:* `scripts/terrain/PointLayer.gd`
*Class name:* `PointLayer`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name PointLayer
extends Control
```

## Public Member Functions

- [`func set_data(d: TerrainData) -> void`](PointLayer/functions/set_data.md) — Assigns TerrainData, resets caches, wires signals, and schedules redraw
- [`func mark_dirty() -> void`](PointLayer/functions/mark_dirty.md) — Marks the whole layer as dirty and queues a redraw (forces full rebuild)
- [`func _on_points_changed(kind: String, ids: PackedInt32Array) -> void`](PointLayer/functions/_on_points_changed.md) — Handles TerrainData point mutations and marks affected points dirty
- [`func _notification(what)`](PointLayer/functions/_notification.md) — Redraw on resize so points match current Control rect.
- [`func _draw() -> void`](PointLayer/functions/_draw.md)
- [`func _upsert_from_data(id: int, rebuild_all: bool) -> void`](PointLayer/functions/_upsert_from_data.md) — Insert/update a point by id, recomputing size/tex/visibility as needed
- [`func _refresh_pose(id: int) -> void`](PointLayer/functions/_refresh_pose.md) — Update only pos/rot/scale/size/visibility
- [`func _rebuild_draw_items() -> void`](PointLayer/functions/_rebuild_draw_items.md) — Build/refresh array used by _draw(), sorted by z
- [`func _is_terrain_pos_visible(pos_local: Vector2) -> bool`](PointLayer/functions/_is_terrain_pos_visible.md) — Reuse your original visibility test against terrain rect
- [`func _find_point_by_id(id: int) -> Variant`](PointLayer/functions/_find_point_by_id.md) — Find a point dictionary in TerrainData by id

## Public Attributes

- `bool antialias` — Enable antialiasing
- `TerrainData data`
- `Dictionary _items`
- `Array _draw_items`
- `TerrainRender renderer`

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

### _on_points_changed

```gdscript
func _on_points_changed(kind: String, ids: PackedInt32Array) -> void
```

Handles TerrainData point mutations and marks affected points dirty

### _notification

```gdscript
func _notification(what)
```

Redraw on resize so points match current Control rect.

### _draw

```gdscript
func _draw() -> void
```

### _upsert_from_data

```gdscript
func _upsert_from_data(id: int, rebuild_all: bool) -> void
```

Insert/update a point by id, recomputing size/tex/visibility as needed

### _refresh_pose

```gdscript
func _refresh_pose(id: int) -> void
```

Update only pos/rot/scale/size/visibility

### _rebuild_draw_items

```gdscript
func _rebuild_draw_items() -> void
```

Build/refresh array used by _draw(), sorted by z

### _is_terrain_pos_visible

```gdscript
func _is_terrain_pos_visible(pos_local: Vector2) -> bool
```

Reuse your original visibility test against terrain rect

### _find_point_by_id

```gdscript
func _find_point_by_id(id: int) -> Variant
```

Find a point dictionary in TerrainData by id

## Member Data Documentation

### antialias

```gdscript
var antialias: bool
```

Decorators: `@export`

Enable antialiasing

### data

```gdscript
var data: TerrainData
```

### _items

```gdscript
var _items: Dictionary
```

### _draw_items

```gdscript
var _draw_items: Array
```

### renderer

```gdscript
var renderer: TerrainRender
```
