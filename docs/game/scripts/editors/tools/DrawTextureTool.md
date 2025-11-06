# DrawTextureTool Class Reference

*File:* `scripts/editors/tools/ScenarioDrawTextureTool.gd`
*Class name:* `DrawTextureTool`
*Inherits:* `ScenarioToolBase`

## Synopsis

```gdscript
class_name DrawTextureTool
extends ScenarioToolBase
```

## Brief

Texture-stamp tool for ScenarioEditor.

## Detailed Description

Places a textured stamp at clicked position.

## Public Member Functions

- [`func _on_activated() -> void`](DrawTextureTool/functions/_on_activated.md) — Activate tool.
- [`func _on_deactivated() -> void`](DrawTextureTool/functions/_on_deactivated.md) — Deactivate tool.
- [`func _on_mouse_move(e: InputEventMouseMotion) -> bool`](DrawTextureTool/functions/_on_mouse_move.md) — Handle mouse move.
- [`func _on_mouse_button(e: InputEventMouseButton) -> bool`](DrawTextureTool/functions/_on_mouse_button.md) — Handle mouse button.
- [`func _on_key(e: InputEventKey) -> bool`](DrawTextureTool/functions/_on_key.md) — Handle key/wheel: Q/E rotate, MouseWheel scale, R reset.
- [`func draw_overlay(canvas: Control) -> void`](DrawTextureTool/functions/draw_overlay.md) — Draw overlay preview.
- [`func _place() -> void`](DrawTextureTool/functions/_place.md) — Commit a stamp.

## Public Attributes

- `Texture2D texture` — Active texture.
- `Color color` — Stamp Color.
- `float scale` — Uniform scale.
- `float rotation_deg` — Rotation in degrees.
- `float opacity` — Opacity [0..1].
- `String label` — Optional text label shown to the right of the stamp.
- `String texture_path`

## Member Function Documentation

### _on_activated

```gdscript
func _on_activated() -> void
```

Activate tool.

### _on_deactivated

```gdscript
func _on_deactivated() -> void
```

Deactivate tool.

### _on_mouse_move

```gdscript
func _on_mouse_move(e: InputEventMouseMotion) -> bool
```

Handle mouse move.
`e` InputEventMouseMotion.
[return] true if consumed.

### _on_mouse_button

```gdscript
func _on_mouse_button(e: InputEventMouseButton) -> bool
```

Handle mouse button.
`e` InputEventMouseButton.
[return] true if consumed.

### _on_key

```gdscript
func _on_key(e: InputEventKey) -> bool
```

Handle key/wheel: Q/E rotate, MouseWheel scale, R reset.
`e` InputEventKey|InputEventMouseButton.
[return] true if consumed.

### draw_overlay

```gdscript
func draw_overlay(canvas: Control) -> void
```

Draw overlay preview.
`canvas` Overlay control.

### _place

```gdscript
func _place() -> void
```

Commit a stamp.

## Member Data Documentation

### texture

```gdscript
var texture: Texture2D
```

Decorators: `@export`

Active texture.

### color

```gdscript
var color: Color
```

Decorators: `@export`

Stamp Color.

### scale

```gdscript
var scale: float
```

Decorators: `@export_range(0.05, 10.0, 0.01)`

Uniform scale.

### rotation_deg

```gdscript
var rotation_deg: float
```

Decorators: `@export_range(-360.0, 360.0, 0.1)`

Rotation in degrees.

### opacity

```gdscript
var opacity: float
```

Decorators: `@export_range(0.0, 1.0, 0.01)`

Opacity [0..1].

### label

```gdscript
var label: String
```

Decorators: `@export`

Optional text label shown to the right of the stamp.

### texture_path

```gdscript
var texture_path: String
```
