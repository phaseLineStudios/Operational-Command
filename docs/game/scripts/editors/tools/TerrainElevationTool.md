# TerrainElevationTool Class Reference

*File:* `scripts/editors/tools/TerrainElevationTool.gd`
*Class name:* `TerrainElevationTool`
*Inherits:* `TerrainToolBase`

## Synopsis

```gdscript
class_name TerrainElevationTool
extends TerrainToolBase
```

## Brief

Inner Class for a circle preview

## Public Member Functions

- [`func _init()`](TerrainElevationTool/functions/_init.md)
- [`func build_preview(overlay_parent: Node) -> Control`](TerrainElevationTool/functions/build_preview.md)
- [`func _place_preview(local_px: Vector2) -> void`](TerrainElevationTool/functions/_place_preview.md)
- [`func build_options_ui(p: Control) -> void`](TerrainElevationTool/functions/build_options_ui.md)
- [`func build_info_ui(parent: Control) -> void`](TerrainElevationTool/functions/build_info_ui.md)
- [`func build_hint_ui(parent: Control) -> void`](TerrainElevationTool/functions/build_hint_ui.md)
- [`func _label(t: String) -> Label`](TerrainElevationTool/functions/_label.md) — Helper function to create a new label
- [`func handle_view_input(event: InputEvent) -> bool`](TerrainElevationTool/functions/handle_view_input.md)
- [`func _apply(pos: Vector2) -> void`](TerrainElevationTool/functions/_apply.md) — Draw elevation change
- [`func _smooth01(x: float) -> float`](TerrainElevationTool/functions/_smooth01.md) — Helper for smooth fade
- [`func _rect_union(a: Rect2i, b: Rect2i) -> Rect2i`](TerrainElevationTool/functions/_rect_union.md) — Helper function to union join a rect
- [`func _brush_rect_px(center_px: Vector2i, r_px: int, img: Image) -> Rect2i`](TerrainElevationTool/functions/_brush_rect_px.md) — Helper function to get brush rect
- [`func _block_from_image(img: Image, rect: Rect2i) -> PackedFloat32Array`](TerrainElevationTool/functions/_block_from_image.md) — Returns a row-major block of elevation samples for the clipped rect.
- [`func _draw() -> void`](TerrainElevationTool/functions/_draw.md)

## Public Attributes

- `int mode`
- `Image _img_before`
- `Rect2i _stroke_rect`

## Enumerations

- `enum Mode` — Elevation editing: raise/lower/smooth brush.

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

### _label

```gdscript
func _label(t: String) -> Label
```

Helper function to create a new label

### handle_view_input

```gdscript
func handle_view_input(event: InputEvent) -> bool
```

### _apply

```gdscript
func _apply(pos: Vector2) -> void
```

Draw elevation change

### _smooth01

```gdscript
func _smooth01(x: float) -> float
```

Helper for smooth fade

### _rect_union

```gdscript
func _rect_union(a: Rect2i, b: Rect2i) -> Rect2i
```

Helper function to union join a rect

### _brush_rect_px

```gdscript
func _brush_rect_px(center_px: Vector2i, r_px: int, img: Image) -> Rect2i
```

Helper function to get brush rect

### _block_from_image

```gdscript
func _block_from_image(img: Image, rect: Rect2i) -> PackedFloat32Array
```

Returns a row-major block of elevation samples for the clipped rect.

### _draw

```gdscript
func _draw() -> void
```

## Member Data Documentation

### mode

```gdscript
var mode: int
```

### _img_before

```gdscript
var _img_before: Image
```

### _stroke_rect

```gdscript
var _stroke_rect: Rect2i
```

## Enumeration Type Documentation

### Mode

```gdscript
enum Mode
```

Elevation editing: raise/lower/smooth brush.
