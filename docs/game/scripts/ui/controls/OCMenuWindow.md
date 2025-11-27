# OCMenuWindow Class Reference

*File:* `scripts/ui/controls/OcMenuWindow.gd`
*Class name:* `OCMenuWindow`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name OCMenuWindow
extends Control
```

## Public Member Functions

- [`func _ready() -> void`](OCMenuWindow/functions/_ready.md)
- [`func _process(_dt: float) -> void`](OCMenuWindow/functions/_process.md)
- [`func popup() -> void`](OCMenuWindow/functions/popup.md) — Show dialog without changing position.
- [`func popup_centered() -> void`](OCMenuWindow/functions/popup_centered.md) — Show dialog centered in parent Control or viewport.
- [`func popup_centered_ratio(ratio: float = 0.75) -> void`](OCMenuWindow/functions/popup_centered_ratio.md) — Show dialog centered and sized to `ratio` of parent/viewport.
- [`func _ok_pressed() -> void`](OCMenuWindow/functions/_ok_pressed.md) — Emitts ok pressed event
- [`func _cancel_pressed() -> void`](OCMenuWindow/functions/_cancel_pressed.md) — Emitts ok pressed event
- [`func _close_pressed() -> void`](OCMenuWindow/functions/_close_pressed.md) — Emitts ok pressed event
- [`func _on_dragbar_gui_input(event: InputEvent) -> void`](OCMenuWindow/functions/_on_dragbar_gui_input.md) — Handles mouse input on the drag bar to drag the window.
- [`func _get_reference_rect_size() -> Vector2`](OCMenuWindow/functions/_get_reference_rect_size.md) — Get size of parent Control if available, otherwise viewport size.

## Public Attributes

- `String window_title` — Title of window
- `OCMenuContainer window`
- `Button close_button`
- `OCMenuButton cancel_button`
- `OCMenuButton ok_button`
- `HBoxContainer _dragbar`
- `Label _title`
- `bool _is_dragging`
- `Vector2 _drag_offset`

## Signals

- `signal ok_pressed` — Emitted when the ok button is pressed.
- `signal cancel_pressed` — Emitted when the cancel button is pressed.
- `signal close_pressed` — Emitted when the close button is pressed.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _process

```gdscript
func _process(_dt: float) -> void
```

### popup

```gdscript
func popup() -> void
```

Show dialog without changing position.

### popup_centered

```gdscript
func popup_centered() -> void
```

Show dialog centered in parent Control or viewport.

### popup_centered_ratio

```gdscript
func popup_centered_ratio(ratio: float = 0.75) -> void
```

Show dialog centered and sized to `ratio` of parent/viewport.
`ratio` Size ratio relative to reference rect (0-1).

### _ok_pressed

```gdscript
func _ok_pressed() -> void
```

Emitts ok pressed event

### _cancel_pressed

```gdscript
func _cancel_pressed() -> void
```

Emitts ok pressed event

### _close_pressed

```gdscript
func _close_pressed() -> void
```

Emitts ok pressed event

### _on_dragbar_gui_input

```gdscript
func _on_dragbar_gui_input(event: InputEvent) -> void
```

Handles mouse input on the drag bar to drag the window.
`event` GUI input event from the drag bar.

### _get_reference_rect_size

```gdscript
func _get_reference_rect_size() -> Vector2
```

Get size of parent Control if available, otherwise viewport size.
[return] Reference rect size for centering.

## Member Data Documentation

### window_title

```gdscript
var window_title: String
```

Decorators: `@export`

Title of window

### window

```gdscript
var window: OCMenuContainer
```

### close_button

```gdscript
var close_button: Button
```

### cancel_button

```gdscript
var cancel_button: OCMenuButton
```

### ok_button

```gdscript
var ok_button: OCMenuButton
```

### _dragbar

```gdscript
var _dragbar: HBoxContainer
```

### _title

```gdscript
var _title: Label
```

### _is_dragging

```gdscript
var _is_dragging: bool
```

### _drag_offset

```gdscript
var _drag_offset: Vector2
```

## Signal Documentation

### ok_pressed

```gdscript
signal ok_pressed
```

Emitted when the ok button is pressed.

### cancel_pressed

```gdscript
signal cancel_pressed
```

Emitted when the cancel button is pressed.

### close_pressed

```gdscript
signal close_pressed
```

Emitted when the close button is pressed.
