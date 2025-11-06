# OCMenuButton Class Reference

*File:* `scripts/ui/controls/OcMenuButton.gd`
*Class name:* `OCMenuButton`
*Inherits:* `Button`

## Synopsis

```gdscript
class_name OCMenuButton
extends Button
```

## Public Member Functions

- [`func _notification(what: int) -> void`](OCMenuButton/functions/_notification.md)
- [`func _draw()`](OCMenuButton/functions/_draw.md)
- [`func _rebuild_noise_tex()`](OCMenuButton/functions/_rebuild_noise_tex.md)
- [`func _draw_noise_overlay()`](OCMenuButton/functions/_draw_noise_overlay.md)

## Public Attributes

- `bool noise_enabled` — Enable/disable noise overlay
- `float noise_opacity`
- `float noise_grain`
- `int noise_seed`
- `ImageTexture _noise_tex`

## Member Function Documentation

### _notification

```gdscript
func _notification(what: int) -> void
```

### _draw

```gdscript
func _draw()
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

### noise_enabled

```gdscript
var noise_enabled: bool
```

Decorators: `@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Enable/Disable noise overlay")`

Enable/disable noise overlay

### noise_opacity

```gdscript
var noise_opacity: float
```

### noise_grain

```gdscript
var noise_grain: float
```

### noise_seed

```gdscript
var noise_seed: int
```

### _noise_tex

```gdscript
var _noise_tex: ImageTexture
```
