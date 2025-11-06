# DrawEraserTool Class Reference

*File:* `scripts/editors/tools/ScenarioDrawEraserTool.gd`
*Class name:* `DrawEraserTool`
*Inherits:* `ScenarioToolBase`

## Synopsis

```gdscript
class_name DrawEraserTool
extends ScenarioToolBase
```

## Brief

Eraser tool for ScenarioEditor.

## Detailed Description

Click on drawings to delete them.

## Public Member Functions

- [`func _on_activated() -> void`](DrawEraserTool/functions/_on_activated.md) — Activate tool.
- [`func _on_deactivated() -> void`](DrawEraserTool/functions/_on_deactivated.md) — Deactivate tool.
- [`func _on_mouse_move(e: InputEventMouseMotion) -> bool`](DrawEraserTool/functions/_on_mouse_move.md) — Handle mouse move.
- [`func _on_mouse_button(e: InputEventMouseButton) -> bool`](DrawEraserTool/functions/_on_mouse_button.md) — Handle mouse button - erase drawing on click.
- [`func _on_key(e: InputEventKey) -> bool`](DrawEraserTool/functions/_on_key.md) — Handle key events.
- [`func draw_overlay(canvas: Control) -> void`](DrawEraserTool/functions/draw_overlay.md) — Draw overlay preview (eraser cursor).
- [`func _find_and_erase_drawing(pos_m: Vector2, pos_px: Vector2) -> bool`](DrawEraserTool/functions/_find_and_erase_drawing.md) — Find and erase a drawing near the click position.
- [`func _is_near_stroke(stroke: ScenarioDrawingStroke, _pos_m: Vector2, pos_px: Vector2) -> bool`](DrawEraserTool/functions/_is_near_stroke.md) — Check if click is near a stroke.
- [`func _is_near_stamp(stamp: ScenarioDrawingStamp, _pos_m: Vector2, pos_px: Vector2) -> bool`](DrawEraserTool/functions/_is_near_stamp.md) — Check if click is near a stamp.
- [`func _point_to_segment_distance(p: Vector2, a: Vector2, b: Vector2) -> float`](DrawEraserTool/functions/_point_to_segment_distance.md) — Calculate distance from point to line segment.

## Public Attributes

- `float cursor_radius_px` — Eraser radius in pixels for visual feedback.
- `Color cursor_color` — Color for eraser cursor.

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

Handle mouse button - erase drawing on click.
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

Draw overlay preview (eraser cursor).
`canvas` Overlay control.

### _find_and_erase_drawing

```gdscript
func _find_and_erase_drawing(pos_m: Vector2, pos_px: Vector2) -> bool
```

Find and erase a drawing near the click position.
`pos_m` Click position in terrain space.
`pos_px` Click position in screen space.
[return] true if a drawing was erased.

### _is_near_stroke

```gdscript
func _is_near_stroke(stroke: ScenarioDrawingStroke, _pos_m: Vector2, pos_px: Vector2) -> bool
```

Check if click is near a stroke.
`stroke` ScenarioDrawingStroke to check.
`pos_m` Click position in terrain space.
`pos_px` Click position in screen space.
[return] true if near the stroke.

### _is_near_stamp

```gdscript
func _is_near_stamp(stamp: ScenarioDrawingStamp, _pos_m: Vector2, pos_px: Vector2) -> bool
```

Check if click is near a stamp.
`stamp` ScenarioDrawingStamp to check.
`pos_m` Click position in terrain space.
`pos_px` Click position in screen space.
[return] true if near the stamp.

### _point_to_segment_distance

```gdscript
func _point_to_segment_distance(p: Vector2, a: Vector2, b: Vector2) -> float
```

Calculate distance from point to line segment.
`p` Point position.
`a` Line segment start.
`b` Line segment end.
[return] Distance in pixels.

## Member Data Documentation

### cursor_radius_px

```gdscript
var cursor_radius_px: float
```

Decorators: `@export`

Eraser radius in pixels for visual feedback.

### cursor_color

```gdscript
var cursor_color: Color
```

Decorators: `@export`

Color for eraser cursor.
