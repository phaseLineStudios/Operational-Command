# TerrainLabelTool Class Reference

*File:* `scripts/editors/tools/TerrainLabelTool.gd`
*Class name:* `TerrainLabelTool`
*Inherits:* `TerrainToolBase`

## Synopsis

```gdscript
class_name TerrainLabelTool
extends TerrainToolBase
```

## Public Member Functions

- [`func _init()`](TerrainLabelTool/functions/_init.md)
- [`func build_preview(overlay_parent: Node) -> Control`](TerrainLabelTool/functions/build_preview.md)
- [`func _place_preview(local_px: Vector2) -> void`](TerrainLabelTool/functions/_place_preview.md)
- [`func _refresh_preview() -> void`](TerrainLabelTool/functions/_refresh_preview.md)
- [`func build_options_ui(parent: Control) -> void`](TerrainLabelTool/functions/build_options_ui.md)
- [`func build_info_ui(parent: Control) -> void`](TerrainLabelTool/functions/build_info_ui.md)
- [`func build_hint_ui(parent: Control) -> void`](TerrainLabelTool/functions/build_hint_ui.md)
- [`func handle_view_input(event: InputEvent) -> bool`](TerrainLabelTool/functions/handle_view_input.md)
- [`func _ensure_surfaces()`](TerrainLabelTool/functions/_ensure_surfaces.md)
- [`func _add_label(local_pos: Vector2, text: String, size: int) -> void`](TerrainLabelTool/functions/_add_label.md)
- [`func _set_label_pos(idx: int, local_pos: Vector2) -> void`](TerrainLabelTool/functions/_set_label_pos.md)
- [`func _remove_label(idx: int) -> void`](TerrainLabelTool/functions/_remove_label.md)
- [`func _pick_label(mouse_global: Vector2) -> int`](TerrainLabelTool/functions/_pick_label.md)
- [`func _label(t: String) -> Label`](TerrainLabelTool/functions/_label.md)
- [`func _queue_free_children(node: Control)`](TerrainLabelTool/functions/_queue_free_children.md)
- [`func _draw() -> void`](TerrainLabelTool/functions/_draw.md)

## Public Attributes

- `String label_text`
- `int label_size`
- `float label_rotation_deg`
- `Dictionary _drag_before`
- `String text`
- `Font font`
- `int font_size`
- `float rot_deg`
- `Color fill_color`
- `Color outline_color`

## Member Function Documentation

### _init

```gdscript
func _init()
```

### build_preview

```gdscript
func build_preview(overlay_parent: Node) -> Control
```

### _place_preview

```gdscript
func _place_preview(local_px: Vector2) -> void
```

### _refresh_preview

```gdscript
func _refresh_preview() -> void
```

### build_options_ui

```gdscript
func build_options_ui(parent: Control) -> void
```

### build_info_ui

```gdscript
func build_info_ui(parent: Control) -> void
```

### build_hint_ui

```gdscript
func build_hint_ui(parent: Control) -> void
```

### handle_view_input

```gdscript
func handle_view_input(event: InputEvent) -> bool
```

### _ensure_surfaces

```gdscript
func _ensure_surfaces()
```

### _add_label

```gdscript
func _add_label(local_pos: Vector2, text: String, size: int) -> void
```

### _set_label_pos

```gdscript
func _set_label_pos(idx: int, local_pos: Vector2) -> void
```

### _remove_label

```gdscript
func _remove_label(idx: int) -> void
```

### _pick_label

```gdscript
func _pick_label(mouse_global: Vector2) -> int
```

### _label

```gdscript
func _label(t: String) -> Label
```

### _queue_free_children

```gdscript
func _queue_free_children(node: Control)
```

### _draw

```gdscript
func _draw() -> void
```

## Member Data Documentation

### label_text

```gdscript
var label_text: String
```

### label_size

```gdscript
var label_size: int
```

### label_rotation_deg

```gdscript
var label_rotation_deg: float
```

### _drag_before

```gdscript
var _drag_before: Dictionary
```

### text

```gdscript
var text: String
```

### font

```gdscript
var font: Font
```

### font_size

```gdscript
var font_size: int
```

### rot_deg

```gdscript
var rot_deg: float
```

### fill_color

```gdscript
var fill_color: Color
```

### outline_color

```gdscript
var outline_color: Color
```
