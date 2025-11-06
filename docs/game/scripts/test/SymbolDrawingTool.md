# SymbolDrawingTool Class Reference

*File:* `scripts/test/SymbolDrawingTool.gd`
*Inherits:* `Control`

## Synopsis

```gdscript
extends Control
```

## Brief

Tool for drawing unit symbols and generating GDScript code using shapes.

## Detailed Description

Place and edit shapes, then click "Generate Code"
to get the GDScript code to paste into UnitSymbolGenerator.

Shape types

Canvas dimensions (larger for easier editing)

Draw circle outline on canvas

Draw ellipse outline on canvas

Draw rounded rectangle on canvas

Shape data structure

## Public Member Functions

- [`func _ready() -> void`](SymbolDrawingTool/functions/_ready.md)
- [`func _set_tool(tool: ShapeType) -> void`](SymbolDrawingTool/functions/_set_tool.md) — Set current drawing tool
- [`func _on_corner_radius_changed(value: float) -> void`](SymbolDrawingTool/functions/_on_corner_radius_changed.md) — Handle corner radius slider
- [`func _input(event: InputEvent) -> void`](SymbolDrawingTool/functions/_input.md) — Handle mouse input for placing/editing shapes
- [`func _is_point_in_canvas(pos: Vector2) -> bool`](SymbolDrawingTool/functions/_is_point_in_canvas.md) — Check if point is within canvas bounds
- [`func _start_placement(pos: Vector2) -> void`](SymbolDrawingTool/functions/_start_placement.md) — Start placing a new shape
- [`func _update_placement(pos: Vector2) -> void`](SymbolDrawingTool/functions/_update_placement.md) — Update shape being placed
- [`func _end_placement() -> void`](SymbolDrawingTool/functions/_end_placement.md) — End shape placement
- [`func _on_canvas_draw() -> void`](SymbolDrawingTool/functions/_on_canvas_draw.md) — Draw canvas with grid, shapes, and guides
- [`func _draw_shape(shape: Shape, selected: bool, preview := false) -> void`](SymbolDrawingTool/functions/_draw_shape.md) — Draw a single shape
- [`func _draw_filled_circle_on_canvas(center: Vector2, radius: float, color: Color) -> void`](SymbolDrawingTool/functions/_draw_filled_circle_on_canvas.md) — Draw filled circle on canvas
- [`func _draw_filled_ellipse_on_canvas(center: Vector2, rx: float, ry: float, color: Color) -> void`](SymbolDrawingTool/functions/_draw_filled_ellipse_on_canvas.md) — Draw filled ellipse on canvas
- [`func _on_clear_pressed() -> void`](SymbolDrawingTool/functions/_on_clear_pressed.md) — Clear all shapes
- [`func _on_delete_pressed() -> void`](SymbolDrawingTool/functions/_on_delete_pressed.md) — Delete selected shape
- [`func _on_generate_pressed() -> void`](SymbolDrawingTool/functions/_on_generate_pressed.md) — Generate GDScript code from shapes
- [`func _point_to_normalized(point: Vector2, canvas_center: Vector2) -> Vector2`](SymbolDrawingTool/functions/_point_to_normalized.md) — Convert canvas point to normalized offset from center
- [`func _format_offset(value: float) -> String`](SymbolDrawingTool/functions/_format_offset.md) — Format offset as string with sign
- [`func _on_copy_pressed() -> void`](SymbolDrawingTool/functions/_on_copy_pressed.md) — Copy generated code to clipboard
- [`func get_bounds() -> Rect2`](SymbolDrawingTool/functions/get_bounds.md)
- [`func is_point_near(pos: Vector2, threshold := 8.0) -> bool`](SymbolDrawingTool/functions/is_point_near.md)

## Public Attributes

- `Array[Shape] _shapes` — Drawing state
- `Shape _current_shape`
- `Shape _selected_shape`
- `Vector2 _drag_start`
- `Control canvas`
- `TextEdit code_output`
- `Button clear_btn`
- `Button generate_btn`
- `Button copy_btn`
- `Button delete_btn`
- `Button line_btn`
- `Button circle_btn`
- `Button ellipse_btn`
- `Button rect_btn`
- `CheckBox filled_check`
- `HSlider corner_slider`
- `Label corner_label`
- `ShapeType type`
- `Vector2 start`
- `Vector2 end`
- `bool filled`
- `float corner_radius`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _set_tool

```gdscript
func _set_tool(tool: ShapeType) -> void
```

Set current drawing tool

### _on_corner_radius_changed

```gdscript
func _on_corner_radius_changed(value: float) -> void
```

Handle corner radius slider

### _input

```gdscript
func _input(event: InputEvent) -> void
```

Handle mouse input for placing/editing shapes

### _is_point_in_canvas

```gdscript
func _is_point_in_canvas(pos: Vector2) -> bool
```

Check if point is within canvas bounds

### _start_placement

```gdscript
func _start_placement(pos: Vector2) -> void
```

Start placing a new shape

### _update_placement

```gdscript
func _update_placement(pos: Vector2) -> void
```

Update shape being placed

### _end_placement

```gdscript
func _end_placement() -> void
```

End shape placement

### _on_canvas_draw

```gdscript
func _on_canvas_draw() -> void
```

Draw canvas with grid, shapes, and guides

### _draw_shape

```gdscript
func _draw_shape(shape: Shape, selected: bool, preview := false) -> void
```

Draw a single shape

### _draw_filled_circle_on_canvas

```gdscript
func _draw_filled_circle_on_canvas(center: Vector2, radius: float, color: Color) -> void
```

Draw filled circle on canvas

### _draw_filled_ellipse_on_canvas

```gdscript
func _draw_filled_ellipse_on_canvas(center: Vector2, rx: float, ry: float, color: Color) -> void
```

Draw filled ellipse on canvas

### _on_clear_pressed

```gdscript
func _on_clear_pressed() -> void
```

Clear all shapes

### _on_delete_pressed

```gdscript
func _on_delete_pressed() -> void
```

Delete selected shape

### _on_generate_pressed

```gdscript
func _on_generate_pressed() -> void
```

Generate GDScript code from shapes

### _point_to_normalized

```gdscript
func _point_to_normalized(point: Vector2, canvas_center: Vector2) -> Vector2
```

Convert canvas point to normalized offset from center

### _format_offset

```gdscript
func _format_offset(value: float) -> String
```

Format offset as string with sign

### _on_copy_pressed

```gdscript
func _on_copy_pressed() -> void
```

Copy generated code to clipboard

### get_bounds

```gdscript
func get_bounds() -> Rect2
```

### is_point_near

```gdscript
func is_point_near(pos: Vector2, threshold := 8.0) -> bool
```

## Member Data Documentation

### _shapes

```gdscript
var _shapes: Array[Shape]
```

Drawing state

### _current_shape

```gdscript
var _current_shape: Shape
```

### _selected_shape

```gdscript
var _selected_shape: Shape
```

### _drag_start

```gdscript
var _drag_start: Vector2
```

### canvas

```gdscript
var canvas: Control
```

### code_output

```gdscript
var code_output: TextEdit
```

### clear_btn

```gdscript
var clear_btn: Button
```

### generate_btn

```gdscript
var generate_btn: Button
```

### copy_btn

```gdscript
var copy_btn: Button
```

### delete_btn

```gdscript
var delete_btn: Button
```

### line_btn

```gdscript
var line_btn: Button
```

### circle_btn

```gdscript
var circle_btn: Button
```

### ellipse_btn

```gdscript
var ellipse_btn: Button
```

### rect_btn

```gdscript
var rect_btn: Button
```

### filled_check

```gdscript
var filled_check: CheckBox
```

### corner_slider

```gdscript
var corner_slider: HSlider
```

### corner_label

```gdscript
var corner_label: Label
```

### type

```gdscript
var type: ShapeType
```

### start

```gdscript
var start: Vector2
```

### end

```gdscript
var end: Vector2
```

### filled

```gdscript
var filled: bool
```

### corner_radius

```gdscript
var corner_radius: float
```
