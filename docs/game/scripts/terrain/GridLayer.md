# GridLayer Class Reference

*File:* `scripts/terrain/GridLayer.gd`
*Class name:* `GridLayer`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name GridLayer
extends Control
```

## Brief

GridLayer.gd

## Public Member Functions

- [`func set_data(d: TerrainData) -> void`](GridLayer/functions/set_data.md)
- [`func apply_style(from: Node) -> void`](GridLayer/functions/apply_style.md) — Apply root style
- [`func mark_dirty() -> void`](GridLayer/functions/mark_dirty.md)
- [`func _notification(what)`](GridLayer/functions/_notification.md)
- [`func _draw()`](GridLayer/functions/_draw.md)
- [`func _bake_grid_texture() -> void`](GridLayer/functions/_bake_grid_texture.md)
- [`func _draw_v_line(img: Image, x: int, lw: float, c: Color) -> void`](GridLayer/functions/_draw_v_line.md)
- [`func _draw_h_line(img: Image, y: int, lw: float, c: Color) -> void`](GridLayer/functions/_draw_h_line.md)

## Public Attributes

- `Color grid_100m_color`
- `Color grid_1km_color`
- `TerrainData data`
- `ImageTexture _grid_tex`

## Member Function Documentation

### set_data

```gdscript
func set_data(d: TerrainData) -> void
```

### apply_style

```gdscript
func apply_style(from: Node) -> void
```

Apply root style

### mark_dirty

```gdscript
func mark_dirty() -> void
```

### _notification

```gdscript
func _notification(what)
```

### _draw

```gdscript
func _draw()
```

### _bake_grid_texture

```gdscript
func _bake_grid_texture() -> void
```

### _draw_v_line

```gdscript
func _draw_v_line(img: Image, x: int, lw: float, c: Color) -> void
```

### _draw_h_line

```gdscript
func _draw_h_line(img: Image, y: int, lw: float, c: Color) -> void
```

## Member Data Documentation

### grid_100m_color

```gdscript
var grid_100m_color: Color
```

### grid_1km_color

```gdscript
var grid_1km_color: Color
```

### data

```gdscript
var data: TerrainData
```

### _grid_tex

```gdscript
var _grid_tex: ImageTexture
```
