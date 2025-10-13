# TriggerConfigDialog Class Reference

*File:* `scripts/editors/TriggerConfigDialog.gd`
*Class name:* `TriggerConfigDialog`
*Inherits:* `Window`

## Synopsis

```gdscript
class_name TriggerConfigDialog
extends Window
```

## Public Member Functions

- [`func _ready() -> void`](TriggerConfigDialog/functions/_ready.md)
- [`func show_for(_editor: ScenarioEditor, index: int) -> void`](TriggerConfigDialog/functions/show_for.md)
- [`func _on_save() -> void`](TriggerConfigDialog/functions/_on_save.md)

## Public Attributes

- `ScenarioEditor editor`
- `ScenarioTrigger _before`
- `Button save_btn`
- `Button close_btn`
- `LineEdit trig_title`
- `OptionButton trig_shape`
- `SpinBox trig_size_x`
- `SpinBox trig_size_y`
- `SpinBox trig_duration`
- `OptionButton trig_presence`
- `TextEdit trig_condition`
- `TextEdit trig_on_activate`
- `TextEdit trig_on_deactivate`

## Signals

- `signal saved(index: int, trigger: ScenarioTrigger)` — Config dialog for ScenarioTrigger.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### show_for

```gdscript
func show_for(_editor: ScenarioEditor, index: int) -> void
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

### _before

```gdscript
var _before: ScenarioTrigger
```

### save_btn

```gdscript
var save_btn: Button
```

### close_btn

```gdscript
var close_btn: Button
```

### trig_title

```gdscript
var trig_title: LineEdit
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

### trig_condition

```gdscript
var trig_condition: TextEdit
```

### trig_on_activate

```gdscript
var trig_on_activate: TextEdit
```

### trig_on_deactivate

```gdscript
var trig_on_deactivate: TextEdit
```

## Signal Documentation

### saved

```gdscript
signal saved(index: int, trigger: ScenarioTrigger)
```

Config dialog for ScenarioTrigger.
