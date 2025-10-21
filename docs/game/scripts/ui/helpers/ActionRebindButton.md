# ActionRebindButton Class Reference

*File:* `scripts/ui/helpers/ActionRebindButton.gd`
*Inherits:* `Button`

## Synopsis

```gdscript
extends Button
```

## Brief

Simple action rebinding button.

## Detailed Description

Click -> capture next input; ESC clears. Shows current binding.

## Public Member Functions

- [`func set_action(new_name: String) -> void`](ActionRebindButton/functions/set_action.md) — Set action programmatically.
- [`func refresh_label() -> void`](ActionRebindButton/functions/refresh_label.md) — Update text from current binding.
- [`func _ready() -> void`](ActionRebindButton/functions/_ready.md)
- [`func _begin_capture() -> void`](ActionRebindButton/functions/_begin_capture.md) — Enter capture mode.
- [`func _unhandled_input(event: InputEvent) -> void`](ActionRebindButton/functions/_unhandled_input.md) — Capture input and assign.

## Public Attributes

- `String action_name` — Action to rebind.

## Member Function Documentation

### set_action

```gdscript
func set_action(new_name: String) -> void
```

Set action programmatically.

### refresh_label

```gdscript
func refresh_label() -> void
```

Update text from current binding.

### _ready

```gdscript
func _ready() -> void
```

### _begin_capture

```gdscript
func _begin_capture() -> void
```

Enter capture mode.

### _unhandled_input

```gdscript
func _unhandled_input(event: InputEvent) -> void
```

Capture input and assign.

## Member Data Documentation

### action_name

```gdscript
var action_name: String
```

Decorators: `@export`

Action to rebind.
