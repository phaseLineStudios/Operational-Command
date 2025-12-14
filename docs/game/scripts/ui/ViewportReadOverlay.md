# ViewportReadOverlay Class Reference

*File:* `scripts/ui/ViewportReadOverlay.gd`
*Class name:* `ViewportReadOverlay`
*Inherits:* `CanvasLayer`

## Synopsis

```gdscript
class_name ViewportReadOverlay
extends CanvasLayer
```

## Public Member Functions

- [`func _ready() -> void`](ViewportReadOverlay/functions/_ready.md)
- [`func open_viewport(viewport: SubViewport, title: String = "", forward_input: bool = true) -> void`](ViewportReadOverlay/functions/open_viewport.md)
- [`func open_texture(texture: Texture2D, title: String = "") -> void`](ViewportReadOverlay/functions/open_texture.md)
- [`func close() -> void`](ViewportReadOverlay/functions/close.md)
- [`func _unhandled_input(event: InputEvent) -> void`](ViewportReadOverlay/functions/_unhandled_input.md)
- [`func _on_texture_gui_input(event: InputEvent) -> void`](ViewportReadOverlay/functions/_on_texture_gui_input.md)
- [`func _on_background_gui_input(event: InputEvent) -> void`](ViewportReadOverlay/functions/_on_background_gui_input.md)
- [`func _map_global_to_viewport_pos(global_pos: Vector2) -> Vector2`](ViewportReadOverlay/functions/_map_global_to_viewport_pos.md)

## Public Attributes

- `bool close_on_background_click`
- `bool forward_input_to_viewport`
- `bool consume_escape`
- `SubViewport _viewport`
- `Vector2i _viewport_size`
- `Control _root`
- `ColorRect _background`
- `Label _title_label`
- `Button _close_button`
- `TextureRect _texture_rect`

## Signals

- `signal closed`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### open_viewport

```gdscript
func open_viewport(viewport: SubViewport, title: String = "", forward_input: bool = true) -> void
```

### open_texture

```gdscript
func open_texture(texture: Texture2D, title: String = "") -> void
```

### close

```gdscript
func close() -> void
```

### _unhandled_input

```gdscript
func _unhandled_input(event: InputEvent) -> void
```

### _on_texture_gui_input

```gdscript
func _on_texture_gui_input(event: InputEvent) -> void
```

### _on_background_gui_input

```gdscript
func _on_background_gui_input(event: InputEvent) -> void
```

### _map_global_to_viewport_pos

```gdscript
func _map_global_to_viewport_pos(global_pos: Vector2) -> Vector2
```

## Member Data Documentation

### close_on_background_click

```gdscript
var close_on_background_click: bool
```

### forward_input_to_viewport

```gdscript
var forward_input_to_viewport: bool
```

### consume_escape

```gdscript
var consume_escape: bool
```

### _viewport

```gdscript
var _viewport: SubViewport
```

### _viewport_size

```gdscript
var _viewport_size: Vector2i
```

### _root

```gdscript
var _root: Control
```

### _background

```gdscript
var _background: ColorRect
```

### _title_label

```gdscript
var _title_label: Label
```

### _close_button

```gdscript
var _close_button: Button
```

### _texture_rect

```gdscript
var _texture_rect: TextureRect
```

## Signal Documentation

### closed

```gdscript
signal closed
```
