# TriggerConfigDialog Class Reference

*File:* `scripts/editors/TriggerConfigDialog.gd`
*Class name:* `TriggerConfigDialog`
*Inherits:* `Window`

## Synopsis

```gdscript
class_name TriggerConfigDialog
extends Window
```

## Brief

Config dialog for ScenarioTrigger.

## Public Member Functions

- [`func _ready() -> void`](TriggerConfigDialog/functions/_ready.md)
- [`func _exit_tree() -> void`](TriggerConfigDialog/functions/_exit_tree.md)
- [`func show_for(_editor: ScenarioEditor, index: int) -> void`](TriggerConfigDialog/functions/show_for.md)
- [`func _on_save() -> void`](TriggerConfigDialog/functions/_on_save.md)
- [`func _setup_autocomplete() -> void`](TriggerConfigDialog/functions/_setup_autocomplete.md) — Setup autocomplete for all code editors with TriggerAPI methods.

## Public Attributes

- `ScenarioEditor editor`
- `ScenarioTrigger _before`
- `CodeEditAutocomplete _autocomplete_condition`
- `CodeEditAutocomplete _autocomplete_activate`
- `CodeEditAutocomplete _autocomplete_deactivate`
- `Button save_btn`
- `Button close_btn`
- `LineEdit trig_id`
- `LineEdit trig_title`
- `SpinBox pos_x_in`
- `SpinBox pos_y_in`
- `OptionButton trig_shape`
- `SpinBox trig_size_x`
- `SpinBox trig_size_y`
- `SpinBox trig_duration`
- `OptionButton trig_presence`
- `CheckBox run_once`
- `CodeEdit trig_condition`
- `CodeEdit trig_on_activate`
- `CodeEdit trig_on_deactivate`

## Signals

- `signal saved(index: int, trigger: ScenarioTrigger)` — Emitted when config is saved.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _exit_tree

```gdscript
func _exit_tree() -> void
```

### show_for

```gdscript
func show_for(_editor: ScenarioEditor, index: int) -> void
```

### _on_save

```gdscript
func _on_save() -> void
```

### _setup_autocomplete

```gdscript
func _setup_autocomplete() -> void
```

Setup autocomplete for all code editors with TriggerAPI methods.

## Member Data Documentation

### editor

```gdscript
var editor: ScenarioEditor
```

### _before

```gdscript
var _before: ScenarioTrigger
```

### _autocomplete_condition

```gdscript
var _autocomplete_condition: CodeEditAutocomplete
```

### _autocomplete_activate

```gdscript
var _autocomplete_activate: CodeEditAutocomplete
```

### _autocomplete_deactivate

```gdscript
var _autocomplete_deactivate: CodeEditAutocomplete
```

### save_btn

```gdscript
var save_btn: Button
```

### close_btn

```gdscript
var close_btn: Button
```

### trig_id

```gdscript
var trig_id: LineEdit
```

### trig_title

```gdscript
var trig_title: LineEdit
```

### pos_x_in

```gdscript
var pos_x_in: SpinBox
```

### pos_y_in

```gdscript
var pos_y_in: SpinBox
```

### trig_shape

```gdscript
var trig_shape: OptionButton
```

### trig_size_x

```gdscript
var trig_size_x: SpinBox
```

### trig_size_y

```gdscript
var trig_size_y: SpinBox
```

### trig_duration

```gdscript
var trig_duration: SpinBox
```

### trig_presence

```gdscript
var trig_presence: OptionButton
```

### run_once

```gdscript
var run_once: CheckBox
```

### trig_condition

```gdscript
var trig_condition: CodeEdit
```

### trig_on_activate

```gdscript
var trig_on_activate: CodeEdit
```

### trig_on_deactivate

```gdscript
var trig_on_deactivate: CodeEdit
```

## Signal Documentation

### saved

```gdscript
signal saved(index: int, trigger: ScenarioTrigger)
```

Emitted when config is saved.
