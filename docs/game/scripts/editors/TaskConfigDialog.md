# TaskConfigDialog Class Reference

*File:* `scripts/editors/TaskConfigDialog.gd`
*Class name:* `TaskConfigDialog`
*Inherits:* `Window`

## Synopsis

```gdscript
class_name TaskConfigDialog
extends Window
```

## Public Member Functions

- [`func _ready() -> void`](TaskConfigDialog/functions/_ready.md)
- [`func show_for(_editor: ScenarioEditor, inst: ScenarioTask) -> void`](TaskConfigDialog/functions/show_for.md)
- [`func _build_form() -> void`](TaskConfigDialog/functions/_build_form.md)
- [`func _on_save() -> void`](TaskConfigDialog/functions/_on_save.md)

## Public Attributes

- `ScenarioEditor editor`
- `ScenarioTask instance`
- `ScenarioTask _before`
- `VBoxContainer form`
- `SpinBox pos_x_in`
- `SpinBox pos_y_in`
- `Button save_btn`
- `Button close_btn`

## Signals

- `signal saved(instance: ScenarioTask)` — Dynamic config dialog for TaskInstance/UnitTask.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### show_for

```gdscript
func show_for(_editor: ScenarioEditor, inst: ScenarioTask) -> void
```

### _build_form

```gdscript
func _build_form() -> void
```

### _on_save

```gdscript
func _on_save() -> void
```

## Member Data Documentation

### editor

```gdscript
var editor: ScenarioEditor
```

### instance

```gdscript
var instance: ScenarioTask
```

### _before

```gdscript
var _before: ScenarioTask
```

### form

```gdscript
var form: VBoxContainer
```

### pos_x_in

```gdscript
var pos_x_in: SpinBox
```

### pos_y_in

```gdscript
var pos_y_in: SpinBox
```

### save_btn

```gdscript
var save_btn: Button
```

### close_btn

```gdscript
var close_btn: Button
```

## Signal Documentation

### saved

```gdscript
signal saved(instance: ScenarioTask)
```

Dynamic config dialog for TaskInstance/UnitTask.

Generates fields from the task's exported properties.
