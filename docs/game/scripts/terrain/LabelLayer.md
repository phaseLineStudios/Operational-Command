# LabelLayer Class Reference

*File:* `scripts/terrain/LabelLayer.gd`
*Class name:* `LabelLayer`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name LabelLayer
extends Control
```

## Brief

Outline thickness in pixels (>=1 draws outline)

## Public Member Functions

- [`func set_data(d: TerrainData) -> void`](LabelLayer/functions/set_data.md) — Assigns TerrainData, resets caches, wires signals, and schedules redraw
- [`func apply_style(from: Node)`](LabelLayer/functions/apply_style.md) — Apply style fields from TerrainRender
- [`func mark_dirty()`](LabelLayer/functions/mark_dirty.md) — Marks the whole layer as dirty and queues a redraw (forces full rebuild)
- [`func _on_labels_changed(kind: String, ids: PackedInt32Array)`](LabelLayer/functions/_on_labels_changed.md) — Handles TerrainData label mutations and marks affected labels dirty
- [`func _notification(what)`](LabelLayer/functions/_notification.md) — Redraw on resize so strokes match current Control rect
- [`func _draw() -> void`](LabelLayer/functions/_draw.md)
- [`func _upsert_from_data(id: int) -> void`](LabelLayer/functions/_upsert_from_data.md) — Insert/update a label from TerrainData
- [`func _refresh_pose_only(id: int) -> void`](LabelLayer/functions/_refresh_pose_only.md) — Update position/rotation only (fast path for drags)
- [`func _rebuild_draw_items() -> void`](LabelLayer/functions/_rebuild_draw_items.md) — Build sorted list from cache
- [`func _draw_label_centered(pos_local: Vector2, text: String, font_size: int, rot_deg: float) -> void`](LabelLayer/functions/_draw_label_centered.md) — Draw a centered label with a robust outline (multi-offset fallback)
- [`func _is_terrain_pos_visible(pos_local: Vector2) -> bool`](LabelLayer/functions/_is_terrain_pos_visible.md) — Visibility test against terrain rect (same as other layers)
- [`func _find_label_by_id(id: int) -> Variant`](LabelLayer/functions/_find_label_by_id.md) — Find a label dictionary in TerrainData by id

## Public Attributes

- `Color outline_color` — Outline color for labels
- `Color text_color` — Fill color for label text
- `Font font` — Font resource used for labels
- `bool antialias` — Unused by text, kept for consistency
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

### apply_style

```gdscript
func apply_style(from: Node)
```

Apply style fields from TerrainRender

### mark_dirty

```gdscript
func mark_dirty()
```

Marks the whole layer as dirty and queues a redraw (forces full rebuild)

### _on_labels_changed

```gdscript
func _on_labels_changed(kind: String, ids: PackedInt32Array)
```

Handles TerrainData label mutations and marks affected labels dirty

### _notification

```gdscript
func _notification(what)
```

Redraw on resize so strokes match current Control rect

### _draw

```gdscript
func _draw() -> void
```

### _upsert_from_data

```gdscript
func _upsert_from_data(id: int) -> void
```

Insert/update a label from TerrainData

### _refresh_pose_only

```gdscript
func _refresh_pose_only(id: int) -> void
```

Update position/rotation only (fast path for drags)

### _rebuild_draw_items

```gdscript
func _rebuild_draw_items() -> void
```

Build sorted list from cache

### _draw_label_centered

```gdscript
func _draw_label_centered(pos_local: Vector2, text: String, font_size: int, rot_deg: float) -> void
```

Draw a centered label with a robust outline (multi-offset fallback)

### _is_terrain_pos_visible

```gdscript
func _is_terrain_pos_visible(pos_local: Vector2) -> bool
```

Visibility test against terrain rect (same as other layers)

### _find_label_by_id

```gdscript
func _find_label_by_id(id: int) -> Variant
```

Find a label dictionary in TerrainData by id

## Member Data Documentation

### outline_color

```gdscript
var outline_color: Color
```

Decorators: `@export`

Outline color for labels

### text_color

```gdscript
var text_color: Color
```

Decorators: `@export`

Fill color for label text

### font

```gdscript
var font: Font
```

Decorators: `@export`

Font resource used for labels

### antialias

```gdscript
var antialias: bool
```

Decorators: `@export`

Unused by text, kept for consistency

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
