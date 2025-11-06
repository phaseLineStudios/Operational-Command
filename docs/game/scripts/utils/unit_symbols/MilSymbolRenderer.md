# MilSymbolRenderer Class Reference

*File:* `scripts/utils/unit_symbols/MilSymbolRenderer.gd`
*Class name:* `MilSymbolRenderer`
*Inherits:* `Node2D`

## Synopsis

```gdscript
class_name MilSymbolRenderer
extends Node2D
```

## Brief

Military symbol renderer using Godot's CanvasItem drawing
Draws military symbols using draw_* methods

Set the symbol to render

Draw a rounded rectangle.

## Detailed Description

`rect` Rect region in px.
`radius` Corner radius in px (clamped to half of min(width, height)).
`color` Fill/line color.
`filled` If true, fills; otherwise draws outline.
`width` Outline width in px (used when !filled).
`segments` Segments per corner arc (>= 2 recommended).

Fill a quarter circle with a triangle fan.
`center` Arc center.
`r` Radius.
`a0` Start angle (rad).
`a1` End angle (rad).
`color` Fill color.
`segments` Arc smoothness (>=2).

## Public Member Functions

- [`func _ready() -> void`](MilSymbolRenderer/functions/_ready.md)
- [`func _calculate_scale() -> void`](MilSymbolRenderer/functions/_calculate_scale.md) — Calculate scale factor to fit symbol into configured size
- [`func _draw() -> void`](MilSymbolRenderer/functions/_draw.md) — Draw the complete symbol
- [`func _draw_frame() -> void`](MilSymbolRenderer/functions/_draw_frame.md) — Draw the base frame geometry
- [`func _draw_icon() -> void`](MilSymbolRenderer/functions/_draw_icon.md) — Draw the unit icon
- [`func _draw_icon_lines(paths: Array, color: Color) -> void`](MilSymbolRenderer/functions/_draw_icon_lines.md) — Draw icon as lines
- [`func _draw_icon_path(path_data: String, color: Color, filled: bool) -> void`](MilSymbolRenderer/functions/_draw_icon_path.md) — Draw icon from SVG path data
- [`func _parse_coord(coord_str: String) -> Vector2`](MilSymbolRenderer/functions/_parse_coord.md) — Parse coordinate from string "x,y"
- [`func _draw_icon_shapes(shapes: Array, color: Color) -> void`](MilSymbolRenderer/functions/_draw_icon_shapes.md) — Draw icon as shapes
- [`func _draw_oval(rect: Rect2, color: Color, filled: bool) -> void`](MilSymbolRenderer/functions/_draw_oval.md) — Draw an oval (ellipse) from rect
- [`func _draw_ellipse(center: Vector2, rx: float, ry: float, color: Color, filled: bool) -> void`](MilSymbolRenderer/functions/_draw_ellipse.md) — Draw an ellipse with center and radii
- [`func _draw_icon_text(text: String, pos: Vector2, size: int, color: Color) -> void`](MilSymbolRenderer/functions/_draw_icon_text.md) — Draw icon text
- [`func _draw_size_indicator() -> void`](MilSymbolRenderer/functions/_draw_size_indicator.md) — Draw size/echelon indicator above the frame
- [`func _draw_unique_designation() -> void`](MilSymbolRenderer/functions/_draw_unique_designation.md) — Draw unique designation below the frame

## Public Attributes

- `MilSymbolConfig config` — Configuration for rendering
- `MilSymbol.UnitAffiliation affiliation` — Symbol properties
- `MilSymbolGeometry.Domain domain`
- `MilSymbol.UnitType icon_type`
- `String unit_size_text` — Text modifiers
- `String unique_designation`
- `float scale_factor` — Scale factor to fit symbol into pixel size
- `int seg`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _calculate_scale

```gdscript
func _calculate_scale() -> void
```

Calculate scale factor to fit symbol into configured size

### _draw

```gdscript
func _draw() -> void
```

Draw the complete symbol

### _draw_frame

```gdscript
func _draw_frame() -> void
```

Draw the base frame geometry

### _draw_icon

```gdscript
func _draw_icon() -> void
```

Draw the unit icon

### _draw_icon_lines

```gdscript
func _draw_icon_lines(paths: Array, color: Color) -> void
```

Draw icon as lines

### _draw_icon_path

```gdscript
func _draw_icon_path(path_data: String, color: Color, filled: bool) -> void
```

Draw icon from SVG path data
Supports basic SVG path commands: M, L, H, V, C, Z

### _parse_coord

```gdscript
func _parse_coord(coord_str: String) -> Vector2
```

Parse coordinate from string "x,y"

### _draw_icon_shapes

```gdscript
func _draw_icon_shapes(shapes: Array, color: Color) -> void
```

Draw icon as shapes

### _draw_oval

```gdscript
func _draw_oval(rect: Rect2, color: Color, filled: bool) -> void
```

Draw an oval (ellipse) from rect

### _draw_ellipse

```gdscript
func _draw_ellipse(center: Vector2, rx: float, ry: float, color: Color, filled: bool) -> void
```

Draw an ellipse with center and radii

### _draw_icon_text

```gdscript
func _draw_icon_text(text: String, pos: Vector2, size: int, color: Color) -> void
```

Draw icon text

### _draw_size_indicator

```gdscript
func _draw_size_indicator() -> void
```

Draw size/echelon indicator above the frame

### _draw_unique_designation

```gdscript
func _draw_unique_designation() -> void
```

Draw unique designation below the frame

## Member Data Documentation

### config

```gdscript
var config: MilSymbolConfig
```

Configuration for rendering

### affiliation

```gdscript
var affiliation: MilSymbol.UnitAffiliation
```

Symbol properties

### domain

```gdscript
var domain: MilSymbolGeometry.Domain
```

### icon_type

```gdscript
var icon_type: MilSymbol.UnitType
```

### unit_size_text

```gdscript
var unit_size_text: String
```

Text modifiers

### unique_designation

```gdscript
var unique_designation: String
```

### scale_factor

```gdscript
var scale_factor: float
```

Scale factor to fit symbol into pixel size

### seg

```gdscript
var seg: int
```
