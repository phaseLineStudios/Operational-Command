# LineLayer Class Reference

*File:* `scripts/terrain/LineLayer.gd`
*Class name:* `LineLayer`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name LineLayer
extends Control
```

## Brief

Snap odd-pixel strokes by offsetting geometry by (0.5, 0.5).

## Detailed Description

Draw a dashed polyline with dash/gap in pixels

Draw a dotted polyline using circles spaced by step_px

## Public Member Functions

- [`func set_data(d: TerrainData) -> void`](LineLayer/functions/set_data.md) — Assigns TerrainData, resets caches, wires signals, and schedules redraw
- [`func mark_dirty() -> void`](LineLayer/functions/mark_dirty.md) — Marks the whole layer as dirty and queues a redraw (forces full rebuild)
- [`func _on_lines_changed(kind: String, ids: PackedInt32Array) -> void`](LineLayer/functions/_on_lines_changed.md) — Handles TerrainData line mutations and marks affected lines dirty
- [`func _notification(what)`](LineLayer/functions/_notification.md) — Redraw on resize so strokes match current Control rect.
- [`func _draw() -> void`](LineLayer/functions/_draw.md)
- [`func _upsert_from_data(id: int, rebuild_recipe: bool) -> void`](LineLayer/functions/_upsert_from_data.md) — Insert/update a line by id from TerrainData and (optionally) rebuild recipe
- [`func _refresh_geometry(id: int) -> void`](LineLayer/functions/_refresh_geometry.md)
- [`func _refresh_recipe_and_geometry(id: int) -> void`](LineLayer/functions/_refresh_recipe_and_geometry.md) — Recompute recipe (colors/mode/widths) and geometry (since snapping may change)
- [`func _rebuild_stroke_batches() -> void`](LineLayer/functions/_rebuild_stroke_batches.md) — Build stroke groups (outline/core) per identical state and sort by z
- [`func _offset_half_px(pts: PackedVector2Array) -> PackedVector2Array`](LineLayer/functions/_offset_half_px.md) — Offset all points by half a pixel to align odd widths to pixel centers
- [`func _draw_polyline_solid(pts: PackedVector2Array, color: Color, width: float) -> void`](LineLayer/functions/_draw_polyline_solid.md) — Draw a solid polyline
- [`func _stroke_key(mode: int, color: Color, width: float, z: int, dash: float, gap: float) -> String`](LineLayer/functions/_stroke_key.md) — Stable key for batching strokes that share draw state
- [`func _find_line_by_id(id: int) -> Variant`](LineLayer/functions/_find_line_by_id.md) — Find a line dictionary in TerrainData by id

## Public Attributes

- `bool antialias` — Antialiasing for draw_polyline/draw_line.
- `TerrainData data`
- `Dictionary _items`
- `Array _strokes`
- `TerrainRender renderer`
- `float dash`
- `float gap`
- `float t1`
- `float cycles`
- `float step`
- `float r`

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

### _on_lines_changed

```gdscript
func _on_lines_changed(kind: String, ids: PackedInt32Array) -> void
```

Handles TerrainData line mutations and marks affected lines dirty

### _notification

```gdscript
func _notification(what)
```

Redraw on resize so strokes match current Control rect.

### _draw

```gdscript
func _draw() -> void
```

### _upsert_from_data

```gdscript
func _upsert_from_data(id: int, rebuild_recipe: bool) -> void
```

Insert/update a line by id from TerrainData and (optionally) rebuild recipe

### _refresh_geometry

```gdscript
func _refresh_geometry(id: int) -> void
```

### _refresh_recipe_and_geometry

```gdscript
func _refresh_recipe_and_geometry(id: int) -> void
```

Recompute recipe (colors/mode/widths) and geometry (since snapping may change)

### _rebuild_stroke_batches

```gdscript
func _rebuild_stroke_batches() -> void
```

Build stroke groups (outline/core) per identical state and sort by z

### _offset_half_px

```gdscript
func _offset_half_px(pts: PackedVector2Array) -> PackedVector2Array
```

Offset all points by half a pixel to align odd widths to pixel centers

### _draw_polyline_solid

```gdscript
func _draw_polyline_solid(pts: PackedVector2Array, color: Color, width: float) -> void
```

Draw a solid polyline

### _stroke_key

```gdscript
func _stroke_key(mode: int, color: Color, width: float, z: int, dash: float, gap: float) -> String
```

Stable key for batching strokes that share draw state

### _find_line_by_id

```gdscript
func _find_line_by_id(id: int) -> Variant
```

Find a line dictionary in TerrainData by id

## Member Data Documentation

### antialias

```gdscript
var antialias: bool
```

Decorators: `@export`

Antialiasing for draw_polyline/draw_line.

### data

```gdscript
var data: TerrainData
```

### _items

```gdscript
var _items: Dictionary
```

### _strokes

```gdscript
var _strokes: Array
```

### renderer

```gdscript
var renderer: TerrainRender
```

### dash

```gdscript
var dash: float
```

### gap

```gdscript
var gap: float
```

### t1

```gdscript
var t1: float
```

### cycles

```gdscript
var cycles: float
```

### step

```gdscript
var step: float
```

### r

```gdscript
var r: float
```
