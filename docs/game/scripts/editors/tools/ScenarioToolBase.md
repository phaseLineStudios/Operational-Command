# ScenarioToolBase Class Reference

*File:* `scripts/editors/tools/ScenarioToolBase.gd`
*Class name:* `ScenarioToolBase`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name ScenarioToolBase
extends Node
```

## Brief

Base class for editor tools (units, triggers, tasks, etc.).

## Detailed Description

Tools receive overlay input and can draw a preview overlay.

## Public Member Functions

- [`func activate(ed: ScenarioEditor) -> void`](ScenarioToolBase/functions/activate.md) — Called by the editor when tool becomes active
- [`func deactivate() -> void`](ScenarioToolBase/functions/deactivate.md) — Called when tool is removed
- [`func handle_input(event: InputEvent) -> bool`](ScenarioToolBase/functions/handle_input.md) — Editor forwards overlay input here
- [`func draw_overlay(_canvas: Control) -> void`](ScenarioToolBase/functions/draw_overlay.md) — Called from overlay _draw().
- [`func build_hint_ui(_parent: Control) -> void`](ScenarioToolBase/functions/build_hint_ui.md) — Short usage hint for the bottom bar
- [`func _on_activated() -> void`](ScenarioToolBase/functions/_on_activated.md)
- [`func _on_deactivated() -> void`](ScenarioToolBase/functions/_on_deactivated.md)
- [`func _on_mouse_move(_e: InputEventMouseMotion) -> bool`](ScenarioToolBase/functions/_on_mouse_move.md)
- [`func _on_mouse_button(_e: InputEventMouseButton) -> bool`](ScenarioToolBase/functions/_on_mouse_button.md)
- [`func _on_key(_e: InputEventKey) -> bool`](ScenarioToolBase/functions/_on_key.md)

## Public Attributes

- `ScenarioEditor editor`
- `TerrainData terrain`

## Signals

- `signal request_redraw_overlay` — Emit when the overlay should redraw
- `signal finished` — Emit when tool finished normally
- `signal canceled` — Emit when tool cancelled

## Member Function Documentation

### activate

```gdscript
func activate(ed: ScenarioEditor) -> void
```

Called by the editor when tool becomes active

### deactivate

```gdscript
func deactivate() -> void
```

Called when tool is removed

### handle_input

```gdscript
func handle_input(event: InputEvent) -> bool
```

Editor forwards overlay input here

### draw_overlay

```gdscript
func draw_overlay(_canvas: Control) -> void
```

Called from overlay _draw(). Override to draw tool visuals

### build_hint_ui

```gdscript
func build_hint_ui(_parent: Control) -> void
```

Short usage hint for the bottom bar

### _on_activated

```gdscript
func _on_activated() -> void
```

### _on_deactivated

```gdscript
func _on_deactivated() -> void
```

### _on_mouse_move

```gdscript
func _on_mouse_move(_e: InputEventMouseMotion) -> bool
```

### _on_mouse_button

```gdscript
func _on_mouse_button(_e: InputEventMouseButton) -> bool
```

### _on_key

```gdscript
func _on_key(_e: InputEventKey) -> bool
```

## Member Data Documentation

### editor

```gdscript
var editor: ScenarioEditor
```

### terrain

```gdscript
var terrain: TerrainData
```

## Signal Documentation

### request_redraw_overlay

```gdscript
signal request_redraw_overlay
```

Decorators: `@warning_ignore("unused_signal")`

Emit when the overlay should redraw

### finished

```gdscript
signal finished
```

Decorators: `@warning_ignore("unused_signal")`

Emit when tool finished normally

### canceled

```gdscript
signal canceled
```

Decorators: `@warning_ignore("unused_signal")`

Emit when tool cancelled
