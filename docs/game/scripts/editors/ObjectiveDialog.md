# ObjectiveDialog Class Reference

*File:* `scripts/editors/ObjectiveDialog.gd`
*Class name:* `ObjectiveDialog`
*Inherits:* `Window`

## Synopsis

```gdscript
class_name ObjectiveDialog
extends Window
```

## Brief

Minimal objective dialog (create + edit ScenarioObjectiveData).

## Public Member Functions

- [`func _ready() -> void`](ObjectiveDialog/functions/_ready.md) — Wire UI elements.
- [`func popup_create() -> void`](ObjectiveDialog/functions/popup_create.md) — Open for creating a new objective (clears fields).
- [`func popup_edit(index: int, obj: ScenarioObjectiveData) -> void`](ObjectiveDialog/functions/popup_edit.md) — Open for editing an objective (prefills fields).
- [`func _on_save() -> void`](ObjectiveDialog/functions/_on_save.md) — Called when user presses Save.
- [`func _on_cancel() -> void`](ObjectiveDialog/functions/_on_cancel.md) — Called when dialog gets cancelled.

## Public Attributes

- `DialogMode _mode`
- `int _edit_index`
- `LineEdit _id`
- `LineEdit _title`
- `TextEdit _success`
- `SpinBox _score`
- `Button _save`
- `Button _cancel`

## Signals

- `signal request_create(obj: ScenarioObjectiveData)` — Request objective create.
- `signal request_update(index: int, obj: ScenarioObjectiveData)` — Request objective update (index comes from caller).
- `signal canceled` — Objective creation/edit cancelled.

## Enumerations

- `enum DialogMode` — Mode the dialog is operating in.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Wire UI elements.

### popup_create

```gdscript
func popup_create() -> void
```

Open for creating a new objective (clears fields).

### popup_edit

```gdscript
func popup_edit(index: int, obj: ScenarioObjectiveData) -> void
```

Open for editing an objective (prefills fields).
`index` Row index in caller’s objectives list.
`obj` Objective to edit.

### _on_save

```gdscript
func _on_save() -> void
```

Called when user presses Save.

### _on_cancel

```gdscript
func _on_cancel() -> void
```

Called when dialog gets cancelled.

## Member Data Documentation

### _mode

```gdscript
var _mode: DialogMode
```

### _edit_index

```gdscript
var _edit_index: int
```

### _id

```gdscript
var _id: LineEdit
```

### _title

```gdscript
var _title: LineEdit
```

### _success

```gdscript
var _success: TextEdit
```

### _score

```gdscript
var _score: SpinBox
```

### _save

```gdscript
var _save: Button
```

### _cancel

```gdscript
var _cancel: Button
```

## Signal Documentation

### request_create

```gdscript
signal request_create(obj: ScenarioObjectiveData)
```

Request objective create.

### request_update

```gdscript
signal request_update(index: int, obj: ScenarioObjectiveData)
```

Request objective update (index comes from caller).

### canceled

```gdscript
signal canceled
```

Objective creation/edit cancelled.

## Enumeration Type Documentation

### DialogMode

```gdscript
enum DialogMode
```

Mode the dialog is operating in.
