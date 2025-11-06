# OCMenuContainer Class Reference

*File:* `scripts/ui/controls/OcMenuContainer.gd`
*Class name:* `OCMenuContainer`
*Inherits:* `PanelContainer`

## Synopsis

```gdscript
class_name OCMenuContainer
extends PanelContainer
```

## Brief

Draws a padded container for menues that continues the general style.

## Public Member Functions

- [`func _ready()`](OCMenuContainer/functions/_ready.md)
- [`func _notification(what: int) -> void`](OCMenuContainer/functions/_notification.md)
- [`func _draw()`](OCMenuContainer/functions/_draw.md)
- [`func _setup()`](OCMenuContainer/functions/_setup.md)
- [`func _draw_grid() -> void`](OCMenuContainer/functions/_draw_grid.md)
- [`func _draw_border()`](OCMenuContainer/functions/_draw_border.md)
- [`func _rebuild_noise_tex()`](OCMenuContainer/functions/_rebuild_noise_tex.md)
- [`func _draw_noise_overlay()`](OCMenuContainer/functions/_draw_noise_overlay.md)

## Public Attributes

- `Vector4i padding` — Content margins in pixels (starting from left going clockwise).
- `Vector4i inner_padding` — Inner content margins (inside border) (starting from left going clockwise).
- `Vector4i border_width` — Border width in pixels (starting from left going clockwise).
- `Color border_color` — Border Color.
- `bool grid_enabled`
- `Vector2 cell_size` — Amount of cells to display (columns, rows)
- `Color line_color` — Grid line color
- `int width_color` — Grid line width
- `bool: noise_enabled` — Enable/disable noise overlay
- `float: noise_opacity`
- `float: noise_grain`
- `int: noise_seed`
- `ImageTexture _noise_tex`

## Member Function Documentation

### _ready

```gdscript
func _ready()
```

### _notification

```gdscript
func _notification(what: int) -> void
```

### _draw

```gdscript
func _draw()
```

### _setup

```gdscript
func _setup()
```

### _draw_grid

```gdscript
func _draw_grid() -> void
```

### _draw_border

```gdscript
func _draw_border()
```

### _rebuild_noise_tex

```gdscript
func _rebuild_noise_tex()
```

### _draw_noise_overlay

```gdscript
func _draw_noise_overlay()
```

## Member Data Documentation

### padding

```gdscript
var padding: Vector4i
```

Decorators: `@export`

Content margins in pixels (starting from left going clockwise).

### inner_padding

```gdscript
var inner_padding: Vector4i
```

Decorators: `@export`

Inner content margins (inside border) (starting from left going clockwise).

### border_width

```gdscript
var border_width: Vector4i
```

Decorators: `@export`

Border width in pixels (starting from left going clockwise).

### border_color

```gdscript
var border_color: Color
```

Decorators: `@export`

Border Color.

### grid_enabled

```gdscript
var grid_enabled: bool
```

### cell_size

```gdscript
var cell_size: Vector2
```

Decorators: `@export`

Amount of cells to display (columns, rows)

### line_color

```gdscript
var line_color: Color
```

Decorators: `@export`

Grid line color

### width_color

```gdscript
var width_color: int
```

Decorators: `@export`

Grid line width

### noise_enabled

```gdscript
var noise_enabled: bool:
```

Decorators: `@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Enable/Disable noise overlay")`

Enable/disable noise overlay

### noise_opacity

```gdscript
var noise_opacity: float:
```

### noise_grain

```gdscript
var noise_grain: float:
```

### noise_seed

```gdscript
var noise_seed: int:
```

### _noise_tex

```gdscript
var _noise_tex: ImageTexture
```
