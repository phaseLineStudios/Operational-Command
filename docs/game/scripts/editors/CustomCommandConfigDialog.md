# CustomCommandConfigDialog Class Reference

*File:* `scripts/editors/CustomCommandConfigDialog.gd`
*Class name:* `CustomCommandConfigDialog`
*Inherits:* `Window`

## Synopsis

```gdscript
class_name CustomCommandConfigDialog
extends Window
```

## Brief

Config dialog for CustomCommand in scenario editor.

## Public Member Functions

- [`func _ready() -> void`](CustomCommandConfigDialog/functions/_ready.md)
- [`func show_for(_editor: ScenarioEditor, index: int) -> void`](CustomCommandConfigDialog/functions/show_for.md) — Show dialog for editing a custom command at the specified index.
- [`func _on_save() -> void`](CustomCommandConfigDialog/functions/_on_save.md)

## Public Attributes

- `ScenarioEditor editor`
- `CustomCommand _before`
- `Button save_btn`
- `Button close_btn`
- `LineEdit cmd_keyword`
- `LineEdit cmd_trigger_id`
- `CheckBox cmd_route_as_order`
- `TextEdit cmd_grammar`

## Signals

- `signal saved(index: int, command: CustomCommand)` — Emitted when custom command is saved.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### show_for

```gdscript
func show_for(_editor: ScenarioEditor, index: int) -> void
```

Show dialog for editing a custom command at the specified index.
`_editor` ScenarioEditor instance.
`index` Index of the command in `member ScenarioData.custom_commands`.

### _on_save

```gdscript
func _on_save() -> void
```

## Member Data Documentation

### editor

```gdscript
var editor: ScenarioEditor
```

### _before

```gdscript
var _before: CustomCommand
```

### save_btn

```gdscript
var save_btn: Button
```

### close_btn

```gdscript
var close_btn: Button
```

### cmd_keyword

```gdscript
var cmd_keyword: LineEdit
```

### cmd_trigger_id

```gdscript
var cmd_trigger_id: LineEdit
```

### cmd_route_as_order

```gdscript
var cmd_route_as_order: CheckBox
```

### cmd_grammar

```gdscript
var cmd_grammar: TextEdit
```

## Signal Documentation

### saved

```gdscript
signal saved(index: int, command: CustomCommand)
```

Emitted when custom command is saved.
