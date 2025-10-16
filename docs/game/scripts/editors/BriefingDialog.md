# BriefingDialog Class Reference

*File:* `scripts/editors/BriefingDialog.gd`
*Class name:* `BriefingDialog`
*Inherits:* `Window`

## Synopsis

```gdscript
class_name BriefingDialog
extends Window
```

## Brief

Briefing editor dialog (create/edit BriefData, manage objectives).

## Public Member Functions

- [`func _ready() -> void`](BriefingDialog/functions/_ready.md) — Wire buttons.
- [`func show_dialog(state: bool, existing: BriefData = null) -> void`](BriefingDialog/functions/show_dialog.md) — Open/close the dialog.
- [`func _load_from_working() -> void`](BriefingDialog/functions/_load_from_working.md) — Load UI from working copy.
- [`func _reset_ui() -> void`](BriefingDialog/functions/_reset_ui.md) — Clear UI to defaults.
- [`func _collect_into_working() -> void`](BriefingDialog/functions/_collect_into_working.md) — Collect UI -> working copy.
- [`func _rebuild_objectives() -> void`](BriefingDialog/functions/_rebuild_objectives.md) — Build objective rows: [Title] [Score] [Edit] [Delete]
- [`func _on_add_objective() -> void`](BriefingDialog/functions/_on_add_objective.md) — Open small dialog to create a new `class ObjectiveData`.
- [`func _on_objective_create(obj: ScenarioObjectiveData) -> void`](BriefingDialog/functions/_on_objective_create.md) — Save `class ScenarioObjectiveData` to scenario.
- [`func _on_objective_update(index: int, obj: ScenarioObjectiveData) -> void`](BriefingDialog/functions/_on_objective_update.md) — Apply edited objective at index (preserve id if it existed).
- [`func _on_save() -> void`](BriefingDialog/functions/_on_save.md) — Save current working copy and notify parent.
- [`func _slug(s: String) -> String`](BriefingDialog/functions/_slug.md) — Make a lightweight slug from title.

## Public Attributes

- `ScenarioEditor editor` — Attached editor.
- `DialogMode dialog_mode`
- `BriefData working`
- `LineEdit title_input`
- `TextEdit enemy_input`
- `TextEdit friendly_input`
- `TextEdit terrain_input`
- `TextEdit mission_input`
- `TextEdit execution_input`
- `TextEdit admin_logi_input`
- `ObjectiveDialog objective_dialog`
- `VBoxContainer objectives_vbox`
- `Button objective_add`
- `Button close_btn`
- `Button save_btn`

## Signals

- `signal request_update(brief: BriefData)` — Emitted when user presses Save with a completed BriefData.

## Enumerations

- `enum DialogMode` — Editing mode for the dialog.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Wire buttons.

### show_dialog

```gdscript
func show_dialog(state: bool, existing: BriefData = null) -> void
```

Open/close the dialog. If `existing` is null -> create mode.
`state` True shows dialog, false hides it.
`existing` Optional briefing data to edit.

### _load_from_working

```gdscript
func _load_from_working() -> void
```

Load UI from working copy.

### _reset_ui

```gdscript
func _reset_ui() -> void
```

Clear UI to defaults.

### _collect_into_working

```gdscript
func _collect_into_working() -> void
```

Collect UI -> working copy.

### _rebuild_objectives

```gdscript
func _rebuild_objectives() -> void
```

Build objective rows: [Title] [Score] [Edit] [Delete]

### _on_add_objective

```gdscript
func _on_add_objective() -> void
```

Open small dialog to create a new `class ObjectiveData`.

### _on_objective_create

```gdscript
func _on_objective_create(obj: ScenarioObjectiveData) -> void
```

Save `class ScenarioObjectiveData` to scenario.

### _on_objective_update

```gdscript
func _on_objective_update(index: int, obj: ScenarioObjectiveData) -> void
```

Apply edited objective at index (preserve id if it existed).

### _on_save

```gdscript
func _on_save() -> void
```

Save current working copy and notify parent.

### _slug

```gdscript
func _slug(s: String) -> String
```

Make a lightweight slug from title.

## Member Data Documentation

### editor

```gdscript
var editor: ScenarioEditor
```

Decorators: `@export`

Attached editor.

### dialog_mode

```gdscript
var dialog_mode: DialogMode
```

### working

```gdscript
var working: BriefData
```

### title_input

```gdscript
var title_input: LineEdit
```

### enemy_input

```gdscript
var enemy_input: TextEdit
```

### friendly_input

```gdscript
var friendly_input: TextEdit
```

### terrain_input

```gdscript
var terrain_input: TextEdit
```

### mission_input

```gdscript
var mission_input: TextEdit
```

### execution_input

```gdscript
var execution_input: TextEdit
```

### admin_logi_input

```gdscript
var admin_logi_input: TextEdit
```

### objective_dialog

```gdscript
var objective_dialog: ObjectiveDialog
```

### objectives_vbox

```gdscript
var objectives_vbox: VBoxContainer
```

### objective_add

```gdscript
var objective_add: Button
```

### close_btn

```gdscript
var close_btn: Button
```

### save_btn

```gdscript
var save_btn: Button
```

## Signal Documentation

### request_update

```gdscript
signal request_update(brief: BriefData)
```

Emitted when user presses Save with a completed BriefData.

## Enumeration Type Documentation

### DialogMode

```gdscript
enum DialogMode
```

Editing mode for the dialog.
