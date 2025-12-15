# PauseMenu Class Reference

*File:* `scripts/ui/PauseMenu.gd`
*Inherits:* `Control`

## Synopsis

```gdscript
extends Control
```

## Public Member Functions

- [`func _ready()`](PauseMenu/functions/_ready.md)
- [`func _build_exit_dialog()`](PauseMenu/functions/_build_exit_dialog.md)
- [`func _build_restart_dialog()`](PauseMenu/functions/_build_restart_dialog.md)
- [`func _on_resume_pressed() -> void`](PauseMenu/functions/_on_resume_pressed.md) — Called on resume button pressed.
- [`func _on_restart_pressed() -> void`](PauseMenu/functions/_on_restart_pressed.md) — Called on restart button pressed.
- [`func _on_restart_requested()`](PauseMenu/functions/_on_restart_requested.md) — Called when restart is requested.
- [`func _on_setting_show() -> void`](PauseMenu/functions/_on_setting_show.md) — Called on settings button pressed.
- [`func _on_setting_hide() -> void`](PauseMenu/functions/_on_setting_hide.md) — called on settings back requested.
- [`func _on_scenarios_pressed() -> void`](PauseMenu/functions/_on_scenarios_pressed.md) — Called on scenario pressed.
- [`func _on_main_menu_pressed() -> void`](PauseMenu/functions/_on_main_menu_pressed.md) — Called on main menu pressed.
- [`func _unhandled_key_input(event: InputEvent) -> void`](PauseMenu/functions/_unhandled_key_input.md)
- [`func _release_interactions() -> void`](PauseMenu/functions/_release_interactions.md)
- [`func _on_exit_editor_pressed() -> void`](PauseMenu/functions/_on_exit_editor_pressed.md) — Called on exit editor button pressed.

## Public Attributes

- `ConfirmationDialog _restart_dialog`
- `ConfirmationDialog _exit_dialog`
- `String _exit_target`
- `Button resume_btn`
- `Button restart_btn`
- `Button settings_btn`
- `Button scenarios_btn`
- `Button main_menu_btn`
- `Button exit_editor_btn`
- `PanelContainer menu_container`
- `Settings settings`

## Signals

- `signal resume_requested`
- `signal restart_requested`

## Member Function Documentation

### _ready

```gdscript
func _ready()
```

### _build_exit_dialog

```gdscript
func _build_exit_dialog()
```

### _build_restart_dialog

```gdscript
func _build_restart_dialog()
```

### _on_resume_pressed

```gdscript
func _on_resume_pressed() -> void
```

Called on resume button pressed.

### _on_restart_pressed

```gdscript
func _on_restart_pressed() -> void
```

Called on restart button pressed.

### _on_restart_requested

```gdscript
func _on_restart_requested()
```

Called when restart is requested.

### _on_setting_show

```gdscript
func _on_setting_show() -> void
```

Called on settings button pressed.

### _on_setting_hide

```gdscript
func _on_setting_hide() -> void
```

called on settings back requested.

### _on_scenarios_pressed

```gdscript
func _on_scenarios_pressed() -> void
```

Called on scenario pressed.

### _on_main_menu_pressed

```gdscript
func _on_main_menu_pressed() -> void
```

Called on main menu pressed.

### _unhandled_key_input

```gdscript
func _unhandled_key_input(event: InputEvent) -> void
```

### _release_interactions

```gdscript
func _release_interactions() -> void
```

### _on_exit_editor_pressed

```gdscript
func _on_exit_editor_pressed() -> void
```

Called on exit editor button pressed.

## Member Data Documentation

### _restart_dialog

```gdscript
var _restart_dialog: ConfirmationDialog
```

### _exit_dialog

```gdscript
var _exit_dialog: ConfirmationDialog
```

### _exit_target

```gdscript
var _exit_target: String
```

### resume_btn

```gdscript
var resume_btn: Button
```

### restart_btn

```gdscript
var restart_btn: Button
```

### settings_btn

```gdscript
var settings_btn: Button
```

### scenarios_btn

```gdscript
var scenarios_btn: Button
```

### main_menu_btn

```gdscript
var main_menu_btn: Button
```

### exit_editor_btn

```gdscript
var exit_editor_btn: Button
```

### menu_container

```gdscript
var menu_container: PanelContainer
```

### settings

```gdscript
var settings: Settings
```

## Signal Documentation

### resume_requested

```gdscript
signal resume_requested
```

### restart_requested

```gdscript
signal restart_requested
```
