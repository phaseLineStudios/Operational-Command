# MissionDialog Class Reference

*File:* `scripts/ui/MissionDialog.gd`
*Inherits:* `Control`

## Synopsis

```gdscript
extends Control
```

## Brief

Modal dialog for displaying mission messages and events.

## Detailed Description

Shows text content with an OK button, optionally pausing the simulation.
Used by TriggerAPI to display narrative moments, objectives, and updates.
Can display a line from the dialog to a position on the map or to a UI node (for tutorials).

Show dialog with message text and optional pause
`text` Message text to display (supports BBCode)
`pause_game` If true, pauses simulation until dialog is dismissed
`sim_world` Reference to SimWorld for pause control
`position_m` Optional position on map (in meters) to draw a line to
`map_controller` Reference to MapController for position conversion
`target_node` Optional node or node path to point at (for tutorials)

## Public Member Functions

- [`func _ready() -> void`](MissionDialog/functions/_ready.md)
- [`func hide_dialog() -> void`](MissionDialog/functions/hide_dialog.md) — Hide dialog and optionally resume game
- [`func _on_ok_pressed() -> void`](MissionDialog/functions/_on_ok_pressed.md) — Handle OK button press
- [`func _process(_delta: float) -> void`](MissionDialog/functions/_process.md) — Update line overlay every frame when visible
- [`func _draw_line() -> void`](MissionDialog/functions/_draw_line.md) — Draw the line from dialog to map position or target node
- [`func _get_closest_edge_point(rect: Rect2, target: Vector2) -> Vector2`](MissionDialog/functions/_get_closest_edge_point.md) — Get the closest point on the rectangle edge to a target position

## Public Attributes

- `Color pos_color` — Color of positional circle
- `Color pos_line_color` — Color of positional line
- `SimWorld _sim`
- `bool _was_paused`
- `bool _should_unpause`
- `MapController _map_controller`
- `Variant _position_m`
- `Variant _target_node`
- `RichTextLabel _text_label`
- `Button _ok_button`
- `Control _line_overlay`

## Signals

- `signal dialog_closed` — Emitted when the dialog is closed.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### hide_dialog

```gdscript
func hide_dialog() -> void
```

Hide dialog and optionally resume game

### _on_ok_pressed

```gdscript
func _on_ok_pressed() -> void
```

Handle OK button press

### _process

```gdscript
func _process(_delta: float) -> void
```

Update line overlay every frame when visible

### _draw_line

```gdscript
func _draw_line() -> void
```

Draw the line from dialog to map position or target node

### _get_closest_edge_point

```gdscript
func _get_closest_edge_point(rect: Rect2, target: Vector2) -> Vector2
```

Get the closest point on the rectangle edge to a target position

## Member Data Documentation

### pos_color

```gdscript
var pos_color: Color
```

Decorators: `@export`

Color of positional circle

### pos_line_color

```gdscript
var pos_line_color: Color
```

Decorators: `@export`

Color of positional line

### _sim

```gdscript
var _sim: SimWorld
```

### _was_paused

```gdscript
var _was_paused: bool
```

### _should_unpause

```gdscript
var _should_unpause: bool
```

### _map_controller

```gdscript
var _map_controller: MapController
```

### _position_m

```gdscript
var _position_m: Variant
```

### _target_node

```gdscript
var _target_node: Variant
```

### _text_label

```gdscript
var _text_label: RichTextLabel
```

### _ok_button

```gdscript
var _ok_button: Button
```

### _line_overlay

```gdscript
var _line_overlay: Control
```

## Signal Documentation

### dialog_closed

```gdscript
signal dialog_closed
```

Emitted when the dialog is closed.
