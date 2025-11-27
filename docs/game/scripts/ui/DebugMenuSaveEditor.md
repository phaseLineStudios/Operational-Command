# DebugMenuSaveEditor Class Reference

*File:* `scripts/ui/DebugMenuSaveEditor.gd`
*Class name:* `DebugMenuSaveEditor`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name DebugMenuSaveEditor
extends RefCounted
```

## Brief

Show dialog to edit unit state

## Detailed Description

Show dialog to select current mission from campaign

## Public Member Functions

- [`func _init(save_name_label: Label, content_grid: GridContainer) -> void`](DebugMenuSaveEditor/functions/_init.md)
- [`func refresh(parent: Node) -> void`](DebugMenuSaveEditor/functions/refresh.md) — Refresh the save editor UI with current save data
- [`func _add_row(label_text: String, value: String, callback: Callable) -> void`](DebugMenuSaveEditor/functions/_add_row.md) — Add a text field row to save editor
- [`func _add_row_int(label_text: String, value: int, callback: Callable) -> void`](DebugMenuSaveEditor/functions/_add_row_int.md) — Add an integer field row to save editor
- [`func _add_separator() -> void`](DebugMenuSaveEditor/functions/_add_separator.md) — Add a separator row
- [`func show_add_mission_dialog(parent: Node, save: CampaignSave) -> void`](DebugMenuSaveEditor/functions/show_add_mission_dialog.md) — Show dialog to add a completed mission
- [`func show_add_unit_state_dialog(parent: Node, save: CampaignSave) -> void`](DebugMenuSaveEditor/functions/show_add_unit_state_dialog.md) — Show dialog to add a new unit state

## Public Attributes

- `Label save_editor_save_name` — Save editor functionality for debug menu.
- `GridContainer save_editor_content`
- `CampaignData campaign`
- `Array[ScenarioData] scenarios`
- `String mission_id`

## Member Function Documentation

### _init

```gdscript
func _init(save_name_label: Label, content_grid: GridContainer) -> void
```

### refresh

```gdscript
func refresh(parent: Node) -> void
```

Refresh the save editor UI with current save data

### _add_row

```gdscript
func _add_row(label_text: String, value: String, callback: Callable) -> void
```

Add a text field row to save editor

### _add_row_int

```gdscript
func _add_row_int(label_text: String, value: int, callback: Callable) -> void
```

Add an integer field row to save editor

### _add_separator

```gdscript
func _add_separator() -> void
```

Add a separator row

### show_add_mission_dialog

```gdscript
func show_add_mission_dialog(parent: Node, save: CampaignSave) -> void
```

Show dialog to add a completed mission

### show_add_unit_state_dialog

```gdscript
func show_add_unit_state_dialog(parent: Node, save: CampaignSave) -> void
```

Show dialog to add a new unit state

## Member Data Documentation

### save_editor_save_name

```gdscript
var save_editor_save_name: Label
```

Save editor functionality for debug menu.

Handles the UI and logic for editing campaign save files in the debug menu.

### save_editor_content

```gdscript
var save_editor_content: GridContainer
```

### campaign

```gdscript
var campaign: CampaignData
```

### scenarios

```gdscript
var scenarios: Array[ScenarioData]
```

### mission_id

```gdscript
var mission_id: String
```
