# DrawFreehandTool Class Reference

*File:* `scripts/editors/tools/ScenarioDrawFreehandTool.gd`
*Class name:* `DrawFreehandTool`
*Inherits:* `ScenarioToolBase`

## Synopsis

```gdscript
class_name DrawFreehandTool
extends ScenarioToolBase
```

## Brief

Freehand draw tool for ScenarioEditor.

## Detailed Description

Draws a polyline while LMB is held.

## Public Member Functions

- [`func _on_activated() -> void`](DrawFreehandTool/functions/_on_activated.md) — Activate tool.
- [`func _on_deactivated() -> void`](DrawFreehandTool/functions/_on_deactivated.md) — Deactivate tool.
- [`func _on_mouse_move(e: InputEventMouseMotion) -> bool`](DrawFreehandTool/functions/_on_mouse_move.md) — Handle mouse move.
- [`func _on_mouse_button(e: InputEventMouseButton) -> bool`](DrawFreehandTool/functions/_on_mouse_button.md) — Handle mouse button.
- [`func _on_key(e: InputEventKey) -> bool`](DrawFreehandTool/functions/_on_key.md) — Handle key events.
- [`func draw_overlay(canvas: Control) -> void`](DrawFreehandTool/functions/draw_overlay.md) — Draw overlay preview.
- [`func _commit_if_valid() -> void`](DrawFreehandTool/functions/_commit_if_valid.md) — Commit current stroke.

## Public Attributes

- `Color color` — Current stroke color.
- `float width_px` — Stroke width in pixels.
- `float opacity` — Opacity [0..1].
- `float min_step_m` — Minimum point spacing in meters to sample.
- `PackedVector2Array _points_m`

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

Handle key events. ESC cancels.
`e` InputEventKey.
[return] true if consumed.

### draw_overlay

```gdscript
func draw_overlay(canvas: Control) -> void
```

Draw overlay preview.
`canvas` Overlay control.

### _commit_if_valid

```gdscript
func _commit_if_valid() -> void
```

Commit current stroke.

## Member Data Documentation

### color

```gdscript
var color: Color
```

Decorators: `@export`

Current stroke color.

### width_px

```gdscript
var width_px: float
```

Decorators: `@export`

Stroke width in pixels.

### opacity

```gdscript
var opacity: float
```

Decorators: `@export_range(0.0, 1.0, 0.01)`

Opacity [0..1].

### min_step_m

```gdscript
var min_step_m: float
```

Decorators: `@export`

Minimum point spacing in meters to sample.

### _points_m

```gdscript
var _points_m: PackedVector2Array
```
