# SlotConfigDialog Class Reference

*File:* `scripts/editors/SlotConfigDialog.gd`
*Class name:* `SlotConfigDialog`
*Inherits:* `Window`

## Synopsis

```gdscript
class_name SlotConfigDialog
extends Window
```

## Public Member Functions

- [`func _ready() -> void`](SlotConfigDialog/functions/_ready.md)
- [`func show_for(_editor: ScenarioEditor, index: int) -> void`](SlotConfigDialog/functions/show_for.md) — Show dialog for a specific slot entry index in editor.ctx.data.unit_slots
- [`func _on_save() -> void`](SlotConfigDialog/functions/_on_save.md) — Save slot config
- [`func _on_role_add()`](SlotConfigDialog/functions/_on_role_add.md) — Add role to role list
- [`func _on_remove_role(role: String)`](SlotConfigDialog/functions/_on_remove_role.md) — Remove a role from role list
- [`func _refresh_role_list()`](SlotConfigDialog/functions/_refresh_role_list.md) — Refresh role list
- [`func show_dialog(state: bool)`](SlotConfigDialog/functions/show_dialog.md) — Show/hide dialog

## Public Attributes

- `ScenarioEditor editor`
- `Array[String] _roles`
- `UnitSlotData _before`
- `LineEdit key_input`
- `LineEdit title_input`
- `LineEdit roles_input`
- `Button roles_add`
- `VBoxContainer roles_list`
- `Button save_btn`
- `Button close_btn`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### show_for

```gdscript
func show_for(_editor: ScenarioEditor, index: int) -> void
```

Show dialog for a specific slot entry index in editor.ctx.data.unit_slots

### _on_save

```gdscript
func _on_save() -> void
```

Save slot config

### _on_role_add

```gdscript
func _on_role_add()
```

Add role to role list

### _on_remove_role

```gdscript
func _on_remove_role(role: String)
```

Remove a role from role list

### _refresh_role_list

```gdscript
func _refresh_role_list()
```

Refresh role list

### show_dialog

```gdscript
func show_dialog(state: bool)
```

Show/hide dialog

## Member Data Documentation

### editor

```gdscript
var editor: ScenarioEditor
```

### _roles

```gdscript
var _roles: Array[String]
```

### _before

```gdscript
var _before: UnitSlotData
```

### key_input

```gdscript
var key_input: LineEdit
```

### title_input

```gdscript
var title_input: LineEdit
```

### roles_input

```gdscript
var roles_input: LineEdit
```

### roles_add

```gdscript
var roles_add: Button
```

### roles_list

```gdscript
var roles_list: VBoxContainer
```

### save_btn

```gdscript
var save_btn: Button
```

### close_btn

```gdscript
var close_btn: Button
```
