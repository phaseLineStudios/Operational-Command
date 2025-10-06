# TerrainPointTool Class Reference

*File:* `scripts/editors/tools/TerrainPointTool.gd`
*Class name:* `TerrainPointTool`
*Inherits:* `TerrainToolBase`

## Synopsis

```gdscript
class_name TerrainPointTool
extends TerrainToolBase
```

## Public Member Functions

- [`func _init()`](TerrainPointTool/functions/_init.md)
- [`func _load_brushes() -> void`](TerrainPointTool/functions/_load_brushes.md)
- [`func build_options_ui(p: Control) -> void`](TerrainPointTool/functions/build_options_ui.md)
- [`func build_info_ui(parent: Control) -> void`](TerrainPointTool/functions/build_info_ui.md)
- [`func build_hint_ui(parent: Control) -> void`](TerrainPointTool/functions/build_hint_ui.md)
- [`func _rebuild_info_ui() -> void`](TerrainPointTool/functions/_rebuild_info_ui.md)
- [`func build_preview(overlay_parent: Node) -> Control`](TerrainPointTool/functions/build_preview.md)
- [`func _place_preview(local_px: Vector2) -> void`](TerrainPointTool/functions/_place_preview.md)
- [`func _update_preview_appearance() -> void`](TerrainPointTool/functions/_update_preview_appearance.md)
- [`func handle_view_input(event: InputEvent) -> bool`](TerrainPointTool/functions/handle_view_input.md)
- [`func _ensure_surfaces()`](TerrainPointTool/functions/_ensure_surfaces.md)
- [`func _add_point(local_m: Vector2) -> void`](TerrainPointTool/functions/_add_point.md)
- [`func _set_point_pos(idx_in_points: int, local_m: Vector2) -> void`](TerrainPointTool/functions/_set_point_pos.md)
- [`func _remove_point(idx_in_points: int) -> void`](TerrainPointTool/functions/_remove_point.md)
- [`func _pick_point(mouse_global: Vector2) -> int`](TerrainPointTool/functions/_pick_point.md)
- [`func _label(t: String) -> Label`](TerrainPointTool/functions/_label.md)
- [`func _queue_free_children(node: Control)`](TerrainPointTool/functions/_queue_free_children.md)
- [`func _get_minimum_size() -> Vector2`](TerrainPointTool/functions/_get_minimum_size.md)
- [`func _draw() -> void`](TerrainPointTool/functions/_draw.md)

## Public Attributes

- `TerrainBrush active_brush`
- `float symbol_scale`
- `Control _info_ui_parent`
- `int _hover_idx`
- `int _drag_idx`
- `Dictionary _drag_before`
- `Texture2D tex`
- `TerrainBrush brush`

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

### _rebuild_info_ui

```gdscript
func _rebuild_info_ui() -> void
```

### build_preview

```gdscript
func build_preview(overlay_parent: Node) -> Control
```

### _place_preview

```gdscript
func _place_preview(local_px: Vector2) -> void
```

### _update_preview_appearance

```gdscript
func _update_preview_appearance() -> void
```

### handle_view_input

```gdscript
func handle_view_input(event: InputEvent) -> bool
```

### _ensure_surfaces

```gdscript
func _ensure_surfaces()
```

### _add_point

```gdscript
func _add_point(local_m: Vector2) -> void
```

### _set_point_pos

```gdscript
func _set_point_pos(idx_in_points: int, local_m: Vector2) -> void
```

### _remove_point

```gdscript
func _remove_point(idx_in_points: int) -> void
```

### _pick_point

```gdscript
func _pick_point(mouse_global: Vector2) -> int
```

### _label

```gdscript
func _label(t: String) -> Label
```

### _queue_free_children

```gdscript
func _queue_free_children(node: Control)
```

### _get_minimum_size

```gdscript
func _get_minimum_size() -> Vector2
```

### _draw

```gdscript
func _draw() -> void
```

## Member Data Documentation

### active_brush

```gdscript
var active_brush: TerrainBrush
```

### symbol_scale

```gdscript
var symbol_scale: float
```

### _info_ui_parent

```gdscript
var _info_ui_parent: Control
```

### _hover_idx

```gdscript
var _hover_idx: int
```

### _drag_idx

```gdscript
var _drag_idx: int
```

### _drag_before

```gdscript
var _drag_before: Dictionary
```

### tex

```gdscript
var tex: Texture2D
```

### brush

```gdscript
var brush: TerrainBrush
```
