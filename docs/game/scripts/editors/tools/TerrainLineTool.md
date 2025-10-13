# TerrainLineTool Class Reference

*File:* `scripts/editors/tools/TerrainLineTool.gd`
*Class name:* `TerrainLineTool`
*Inherits:* `TerrainToolBase`

## Synopsis

```gdscript
class_name TerrainLineTool
extends TerrainToolBase
```

## Public Member Functions

- [`func _init()`](TerrainLineTool/functions/_init.md)
- [`func _load_brushes() -> void`](TerrainLineTool/functions/_load_brushes.md)
- [`func build_preview(parent: Node) -> Control`](TerrainLineTool/functions/build_preview.md)
- [`func _place_preview(_local_px: Vector2) -> void`](TerrainLineTool/functions/_place_preview.md)
- [`func update_preview_at_overlay(_overlay: Control, _overlay_pos: Vector2)`](TerrainLineTool/functions/update_preview_at_overlay.md)
- [`func _queue_preview_redraw() -> void`](TerrainLineTool/functions/_queue_preview_redraw.md)
- [`func build_options_ui(p: Control) -> void`](TerrainLineTool/functions/build_options_ui.md)
- [`func build_info_ui(parent: Control) -> void`](TerrainLineTool/functions/build_info_ui.md)
- [`func build_hint_ui(parent: Control) -> void`](TerrainLineTool/functions/build_hint_ui.md)
- [`func _rebuild_info_ui()`](TerrainLineTool/functions/_rebuild_info_ui.md)
- [`func handle_view_input(event: InputEvent) -> bool`](TerrainLineTool/functions/handle_view_input.md)
- [`func _start_new_line() -> void`](TerrainLineTool/functions/_start_new_line.md)
- [`func _current_points() -> PackedVector2Array`](TerrainLineTool/functions/_current_points.md)
- [`func _find_edit_index_by_id() -> int`](TerrainLineTool/functions/_find_edit_index_by_id.md)
- [`func _cancel_edit_delete_line() -> void`](TerrainLineTool/functions/_cancel_edit_delete_line.md)
- [`func _finish_edit_keep_line() -> void`](TerrainLineTool/functions/_finish_edit_keep_line.md)
- [`func _sync_edit_brush_to_active_if_needed() -> void`](TerrainLineTool/functions/_sync_edit_brush_to_active_if_needed.md)
- [`func _pick_point(pos: Vector2) -> int`](TerrainLineTool/functions/_pick_point.md)
- [`func _label(t: String) -> Label`](TerrainLineTool/functions/_label.md)
- [`func _queue_free_children(node: Control)`](TerrainLineTool/functions/_queue_free_children.md)
- [`func _ensure_current_line_idx() -> int`](TerrainLineTool/functions/_ensure_current_line_idx.md) — Ensure _edit_idx points at the line with _edit_id, return index or -1
- [`func _draw() -> void`](TerrainLineTool/functions/_draw.md)

## Public Attributes

- `TerrainBrush active_brush`
- `float line_width_px`
- `Control _info_ui_parent`
- `int _edit_id`
- `int _edit_idx`
- `int _drag_idx`
- `int _hover_idx`
- `Dictionary _drag_before`
- `float _width_before`
- `int _next_id`
- `TerrainLineTool tool`

## Member Function Documentation

### _init

```gdscript
func _init()
```

### _load_brushes

```gdscript
func _load_brushes() -> void
```

### build_preview

```gdscript
func build_preview(parent: Node) -> Control
```

### _place_preview

```gdscript
func _place_preview(_local_px: Vector2) -> void
```

### update_preview_at_overlay

```gdscript
func update_preview_at_overlay(_overlay: Control, _overlay_pos: Vector2)
```

### _queue_preview_redraw

```gdscript
func _queue_preview_redraw() -> void
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

### _rebuild_info_ui

```gdscript
func _rebuild_info_ui()
```

### handle_view_input

```gdscript
func handle_view_input(event: InputEvent) -> bool
```

### _start_new_line

```gdscript
func _start_new_line() -> void
```

### _current_points

```gdscript
func _current_points() -> PackedVector2Array
```

### _find_edit_index_by_id

```gdscript
func _find_edit_index_by_id() -> int
```

### _cancel_edit_delete_line

```gdscript
func _cancel_edit_delete_line() -> void
```

### _finish_edit_keep_line

```gdscript
func _finish_edit_keep_line() -> void
```

### _sync_edit_brush_to_active_if_needed

```gdscript
func _sync_edit_brush_to_active_if_needed() -> void
```

### _pick_point

```gdscript
func _pick_point(pos: Vector2) -> int
```

### _label

```gdscript
func _label(t: String) -> Label
```

### _queue_free_children

```gdscript
func _queue_free_children(node: Control)
```

### _ensure_current_line_idx

```gdscript
func _ensure_current_line_idx() -> int
```

Ensure _edit_idx points at the line with _edit_id, return index or -1

### _draw

```gdscript
func _draw() -> void
```

## Member Data Documentation

### active_brush

```gdscript
var active_brush: TerrainBrush
```

### line_width_px

```gdscript
var line_width_px: float
```

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

### _width_before

```gdscript
var _width_before: float
```

### _next_id

```gdscript
var _next_id: int
```

### tool

```gdscript
var tool: TerrainLineTool
```
