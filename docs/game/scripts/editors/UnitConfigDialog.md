# UnitConfigDialog Class Reference

*File:* `scripts/editors/UnitConfigDialog.gd`
*Class name:* `UnitConfigDialog`
*Inherits:* `Window`

## Synopsis

```gdscript
class_name UnitConfigDialog
extends Window
```

## Public Member Functions

- [`func _ready() -> void`](UnitConfigDialog/functions/_ready.md)
- [`func show_for(_editor: ScenarioEditor, index: int) -> void`](UnitConfigDialog/functions/show_for.md) — Open dialog for a unit index in editor.ctx.data.units
- [`func _on_save() -> void`](UnitConfigDialog/functions/_on_save.md)

## Public Attributes

- `ScenarioEditor editor` — Edit a ScenarioUnit (callsign, affiliation, combat, behaviour)
- `ScenarioUnit _before`
- `LineEdit callsign_in`
- `OptionButton aff_in`
- `OptionButton combat_in`
- `OptionButton beh_in`
- `SpinBox pos_x_in`
- `SpinBox pos_y_in`
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

Open dialog for a unit index in editor.ctx.data.units

### _on_save

```gdscript
func _on_save() -> void
```

## Member Data Documentation

### editor

```gdscript
var editor: ScenarioEditor
```

Edit a ScenarioUnit (callsign, affiliation, combat, behaviour)

Double-click or context menu opens this dialog

### _before

```gdscript
var _before: ScenarioUnit
```

### callsign_in

```gdscript
var callsign_in: LineEdit
```

### aff_in

```gdscript
var aff_in: OptionButton
```

### combat_in

```gdscript
var combat_in: OptionButton
```

### beh_in

```gdscript
var beh_in: OptionButton
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
