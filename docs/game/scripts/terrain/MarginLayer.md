# MarginLayer Class Reference

*File:* `scripts/terrain/MapMargin.gd`
*Class name:* `MarginLayer`
*Inherits:* `PanelContainer`

## Synopsis

```gdscript
class_name MarginLayer
extends PanelContainer
```

## Brief

Font size for map title

## Detailed Description

Font of grid number

Helper function to draw vertically centered text

## Public Member Functions

- [`func set_data(d: TerrainData) -> void`](MarginLayer/functions/set_data.md) — API to set terrain data
- [`func apply_style(from: Node) -> void`](MarginLayer/functions/apply_style.md) — Apply root style
- [`func mark_dirty()`](MarginLayer/functions/mark_dirty.md) — Mark dirty for redraw
- [`func _notification(what)`](MarginLayer/functions/_notification.md) — Redraw margin on resize
- [`func _draw() -> void`](MarginLayer/functions/_draw.md)
- [`func _draw_text_center(text: String, pos: Vector2, font_size: int = label_size) -> void`](MarginLayer/functions/_draw_text_center.md) — Helper function to draw horizontally centered text

## Public Attributes

- `int title_size`
- `Color margin_color` — Color of outer margin
- `int margin_top_px` — Size of outer margin top
- `int margin_bottom_px` — Size of outer margin bottom
- `int margin_left_px` — Size of outer margin left
- `int margin_right_px` — Size of outer margin right
- `int margin_label_every_m` — When to show a grid number (per meter)
- `Color label_color` — Color of grid number
- `Font label_font`
- `int label_size` — Font size of grid number
- `bool show_top` — Show grid numbers at top
- `bool show_bottom` — Show grid numbers at bottom
- `bool show_left` — Show grid numbers at left
- `bool show_right` — Show grid numbers at right
- `float base_border_px` — width of map border
- `float offset_top_px` — grid number offset top
- `float offset_bottom_px` — grid number offset bottom
- `float offset_left_px` — grid number offset left
- `float offset_right_px` — grid number offset right
- `TerrainData data`

## Member Function Documentation

### set_data

```gdscript
func set_data(d: TerrainData) -> void
```

API to set terrain data

### apply_style

```gdscript
func apply_style(from: Node) -> void
```

Apply root style

### mark_dirty

```gdscript
func mark_dirty()
```

Mark dirty for redraw

### _notification

```gdscript
func _notification(what)
```

Redraw margin on resize

### _draw

```gdscript
func _draw() -> void
```

### _draw_text_center

```gdscript
func _draw_text_center(text: String, pos: Vector2, font_size: int = label_size) -> void
```

Helper function to draw horizontally centered text

## Member Data Documentation

### title_size

```gdscript
var title_size: int
```

### margin_color

```gdscript
var margin_color: Color
```

Color of outer margin

### margin_top_px

```gdscript
var margin_top_px: int
```

Size of outer margin top

### margin_bottom_px

```gdscript
var margin_bottom_px: int
```

Size of outer margin bottom

### margin_left_px

```gdscript
var margin_left_px: int
```

Size of outer margin left

### margin_right_px

```gdscript
var margin_right_px: int
```

Size of outer margin right

### margin_label_every_m

```gdscript
var margin_label_every_m: int
```

When to show a grid number (per meter)

### label_color

```gdscript
var label_color: Color
```

Color of grid number

### label_font

```gdscript
var label_font: Font
```

### label_size

```gdscript
var label_size: int
```

Font size of grid number

### show_top

```gdscript
var show_top: bool
```

Show grid numbers at top

### show_bottom

```gdscript
var show_bottom: bool
```

Show grid numbers at bottom

### show_left

```gdscript
var show_left: bool
```

Show grid numbers at left

### show_right

```gdscript
var show_right: bool
```

Show grid numbers at right

### base_border_px

```gdscript
var base_border_px: float
```

width of map border

### offset_top_px

```gdscript
var offset_top_px: float
```

grid number offset top

### offset_bottom_px

```gdscript
var offset_bottom_px: float
```

grid number offset bottom

### offset_left_px

```gdscript
var offset_left_px: float
```

grid number offset left

### offset_right_px

```gdscript
var offset_right_px: float
```

grid number offset right

### data

```gdscript
var data: TerrainData
```
