# MainMenu Class Reference

*File:* `scripts/ui/MainMenu.gd`
*Inherits:* `Control`

## Synopsis

```gdscript
extends Control
```

## Brief

The main menu UI controller.

## Detailed Description

Controls and manages the main menu scene flow.

Scene registry.

Labels for submenu buttons

## Public Member Functions

- [`func _ready() -> void`](MainMenu/functions/_ready.md)
- [`func _go(key: String) -> void`](MainMenu/functions/_go.md) — Change scene by key in SCENES.
- [`func _quit() -> void`](MainMenu/functions/_quit.md)
- [`func _show_missing_scene_dialog(key: String, path: String) -> void`](MainMenu/functions/_show_missing_scene_dialog.md) — Used in development for missing scenes.
- [`func _wrap_editor_button() -> void`](MainMenu/functions/_wrap_editor_button.md) — Reparents the Editor button into a VBox to host submenu buttons below it.
- [`func _build_submenu_buttons() -> void`](MainMenu/functions/_build_submenu_buttons.md) — Creates 3 submenu buttons and wires them to scene changes.
- [`func _on_editor_pressed() -> void`](MainMenu/functions/_on_editor_pressed.md) — Toggle handler for the Editor button.
- [`func _expand_submenu() -> void`](MainMenu/functions/_expand_submenu.md) — Expand the submenu below the Editor button.
- [`func _collapse_submenu() -> void`](MainMenu/functions/_collapse_submenu.md) — Collapse the submenu.
- [`func _collapse_if_needed() -> void`](MainMenu/functions/_collapse_if_needed.md) — Collapse submenu only if expanded
- [`func _queue_free_children(node: Node) -> void`](MainMenu/functions/_queue_free_children.md)
- [`func _clear_children(node: Node) -> void`](MainMenu/functions/_clear_children.md)

## Public Attributes

- `SubmenuState _state`
- `VBoxContainer _editor_wrapper`
- `VBoxContainer _submenu_holder`
- `VBoxContainer menu_hbox`
- `Button btn_campaign`
- `Button btn_scenarios`
- `Button btn_multiplayer`
- `Button btn_editor`
- `Button btn_settings`
- `Button btn_quit`

## Enumerations

- `enum SubmenuState` — Internal state for submenu visibility.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _go

```gdscript
func _go(key: String) -> void
```

Change scene by key in SCENES.

### _quit

```gdscript
func _quit() -> void
```

### _show_missing_scene_dialog

```gdscript
func _show_missing_scene_dialog(key: String, path: String) -> void
```

Used in development for missing scenes.

### _wrap_editor_button

```gdscript
func _wrap_editor_button() -> void
```

Reparents the Editor button into a VBox to host submenu buttons below it.

### _build_submenu_buttons

```gdscript
func _build_submenu_buttons() -> void
```

Creates 3 submenu buttons and wires them to scene changes.

### _on_editor_pressed

```gdscript
func _on_editor_pressed() -> void
```

Toggle handler for the Editor button.

### _expand_submenu

```gdscript
func _expand_submenu() -> void
```

Expand the submenu below the Editor button.

### _collapse_submenu

```gdscript
func _collapse_submenu() -> void
```

Collapse the submenu.

### _collapse_if_needed

```gdscript
func _collapse_if_needed() -> void
```

Collapse submenu only if expanded

### _queue_free_children

```gdscript
func _queue_free_children(node: Node) -> void
```

### _clear_children

```gdscript
func _clear_children(node: Node) -> void
```

## Member Data Documentation

### _state

```gdscript
var _state: SubmenuState
```

### _editor_wrapper

```gdscript
var _editor_wrapper: VBoxContainer
```

### _submenu_holder

```gdscript
var _submenu_holder: VBoxContainer
```

### menu_hbox

```gdscript
var menu_hbox: VBoxContainer
```

### btn_campaign

```gdscript
var btn_campaign: Button
```

### btn_scenarios

```gdscript
var btn_scenarios: Button
```

### btn_multiplayer

```gdscript
var btn_multiplayer: Button
```

### btn_editor

```gdscript
var btn_editor: Button
```

### btn_settings

```gdscript
var btn_settings: Button
```

### btn_quit

```gdscript
var btn_quit: Button
```

## Enumeration Type Documentation

### SubmenuState

```gdscript
enum SubmenuState
```

Internal state for submenu visibility.
