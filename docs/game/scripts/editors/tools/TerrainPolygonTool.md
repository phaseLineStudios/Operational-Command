# TerrainPolygonTool Class Reference

*File:* `scripts/editors/tools/TerrainPolygonTool.gd`
*Class name:* `TerrainPolygonTool`
*Inherits:* `TerrainToolBase`

## Synopsis

```gdscript
class_name TerrainPolygonTool
extends TerrainToolBase
```

## Brief

Class to draw a point handle

## Public Member Functions

- [`func _init()`](TerrainPolygonTool/functions/_init.md)
- [`func _load_brushes() -> void`](TerrainPolygonTool/functions/_load_brushes.md)
- [`func build_options_ui(p: Control) -> void`](TerrainPolygonTool/functions/build_options_ui.md)
- [`func build_info_ui(parent: Control) -> void`](TerrainPolygonTool/functions/build_info_ui.md)
- [`func build_hint_ui(parent: Control) -> void`](TerrainPolygonTool/functions/build_hint_ui.md)
- [`func build_preview(overlay_parent: Node) -> Control`](TerrainPolygonTool/functions/build_preview.md)
- [`func _place_preview(_local_px: Vector2) -> void`](TerrainPolygonTool/functions/_place_preview.md)
- [`func update_preview_at_overlay(_overlay: Control, _overlay_pos: Vector2)`](TerrainPolygonTool/functions/update_preview_at_overlay.md)
- [`func handle_view_input(event: InputEvent) -> bool`](TerrainPolygonTool/functions/handle_view_input.md)
- [`func _rebuild_info_ui()`](TerrainPolygonTool/functions/_rebuild_info_ui.md) — Rebuild the Info UI with info on the active brush
- [`func _current_points() -> PackedVector2Array`](TerrainPolygonTool/functions/_current_points.md) — retrieve current polygon points
- [`func _find_edit_index_by_id() -> int`](TerrainPolygonTool/functions/_find_edit_index_by_id.md) — Helper function to find current polygon in Terrain Data
- [`func _start_new_polygon() -> void`](TerrainPolygonTool/functions/_start_new_polygon.md) — Start creating a new polygon
- [`func _cancel_edit_delete_polygon() -> void`](TerrainPolygonTool/functions/_cancel_edit_delete_polygon.md) — Delete polygon
- [`func _finish_edit_keep_polygon() -> void`](TerrainPolygonTool/functions/_finish_edit_keep_polygon.md) — Stop editing and save polygon
- [`func _pick_point(pos: Vector2) -> int`](TerrainPolygonTool/functions/_pick_point.md) — Function to pick a point at position
- [`func _label(t: String) -> Label`](TerrainPolygonTool/functions/_label.md) — Helper function to create a new label
- [`func _queue_free_children(node: Control)`](TerrainPolygonTool/functions/_queue_free_children.md) — Helper function to delete all children of a parent node
- [`func _queue_preview_redraw() -> void`](TerrainPolygonTool/functions/_queue_preview_redraw.md) — Queue a redraw of the preview
- [`func _ensure_current_poly_idx() -> int`](TerrainPolygonTool/functions/_ensure_current_poly_idx.md) — Ensure _edit_idx points at the polygon with _edit_id, return index or -1
- [`func _draw() -> void`](TerrainPolygonTool/functions/_draw.md)

## Public Attributes

- `TerrainBrush active_brush` — Elevation editing: raise/lower/smooth brush.
- `Control _info_ui_parent`
- `int _edit_id`
- `int _edit_idx`
- `int _drag_idx`
- `int _hover_idx`
- `Dictionary _drag_before`
- `int _next_id`
- `TerrainPolygonTool tool`

## Member Function Documentation

### _init

```gdscript
func _init()
```

### _load_brushes

```gdscript
func _load_brushes() -> void
```

### build_options_ui

```gdscript
func build_options_ui(p: Control) -> void
```

### build_info_ui

```gdscript
func build_info_ui(parent: Control) -> void
```

### build_hint_ui

```gdscript
func build_hint_ui(parent: Control) -> void
```

### build_preview

```gdscript
func build_preview(overlay_parent: Node) -> Control
```

### _place_preview

```gdscript
func _place_preview(_local_px: Vector2) -> void
```

### update_preview_at_overlay

```gdscript
func update_preview_at_overlay(_overlay: Control, _overlay_pos: Vector2)
```

### handle_view_input

```gdscript
func handle_view_input(event: InputEvent) -> bool
```

### _rebuild_info_ui

```gdscript
func _rebuild_info_ui()
```

Rebuild the Info UI with info on the active brush

### _current_points

```gdscript
func _current_points() -> PackedVector2Array
```

retrieve current polygon points

### _find_edit_index_by_id

```gdscript
func _find_edit_index_by_id() -> int
```

Helper function to find current polygon in Terrain Data

### _start_new_polygon

```gdscript
func _start_new_polygon() -> void
```

Start creating a new polygon

### _cancel_edit_delete_polygon

```gdscript
func _cancel_edit_delete_polygon() -> void
```

Delete polygon

### _finish_edit_keep_polygon

```gdscript
func _finish_edit_keep_polygon() -> void
```

Stop editing and save polygon

### _pick_point

```gdscript
func _pick_point(pos: Vector2) -> int
```

Function to pick a point at position

### _label

```gdscript
func _label(t: String) -> Label
```

Helper function to create a new label

### _queue_free_children

```gdscript
func _queue_free_children(node: Control)
```

Helper function to delete all children of a parent node

### _queue_preview_redraw

```gdscript
func _queue_preview_redraw() -> void
```

Queue a redraw of the preview

### _ensure_current_poly_idx

```gdscript
func _ensure_current_poly_idx() -> int
```

Ensure _edit_idx points at the polygon with _edit_id, return index or -1

### _draw

```gdscript
func _draw() -> void
```

## Member Data Documentation

### active_brush

```gdscript
var active_brush: TerrainBrush
```

Decorators: `@export`

Elevation editing: raise/lower/smooth brush.

### _info_ui_parent

```gdscript
var _info_ui_parent: Control
```

### _edit_id

```gdscript
var _edit_id: int
```

### _edit_idx

```gdscript
var _edit_idx: int
```

### _drag_idx

```gdscript
var _drag_idx: int
```

### _hover_idx

```gdscript
var _hover_idx: int
```

### _drag_before

```gdscript
var _drag_before: Dictionary
```

### _next_id

```gdscript
var _next_id: int
```

### tool

```gdscript
var tool: TerrainPolygonTool
```
