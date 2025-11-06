# ScenarioEditorFileOps Class Reference

*File:* `scripts/editors/helpers/ScenarioEditorFileOps.gd`
*Class name:* `ScenarioEditorFileOps`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name ScenarioEditorFileOps
extends RefCounted
```

## Brief

Helper for managing file operations in the Scenario Editor.

## Detailed Description

Handles file dialogs, save/open/save-as commands, path tracking,
dirty flag management, and discard confirmation.

Current file path (empty if unsaved)

Whether scenario has unsaved changes

## Public Member Functions

- [`func init(parent: ScenarioEditor) -> void`](ScenarioEditorFileOps/functions/init.md) — Initialize with parent editor reference.
- [`func _init_file_dialogs() -> void`](ScenarioEditorFileOps/functions/_init_file_dialogs.md) — Create and configure FileDialog instances.
- [`func cmd_save() -> void`](ScenarioEditorFileOps/functions/cmd_save.md) — Save to current path or fallback to Save As.
- [`func cmd_save_as() -> void`](ScenarioEditorFileOps/functions/cmd_save_as.md) — Show Save As dialog with suggested filename.
- [`func cmd_open() -> void`](ScenarioEditorFileOps/functions/cmd_open.md) — Show Open dialog (asks to discard if dirty).
- [`func _on_open_file_selected(path: String) -> void`](ScenarioEditorFileOps/functions/_on_open_file_selected.md) — Handle file selection to open a scenario.
- [`func _on_save_file_selected(path: String) -> void`](ScenarioEditorFileOps/functions/_on_save_file_selected.md) — Handle file selection to save a scenario.
- [`func on_new_scenario(d: ScenarioData) -> void`](ScenarioEditorFileOps/functions/on_new_scenario.md) — Apply brand-new scenario data from dialog.
- [`func confirm_discard() -> bool`](ScenarioEditorFileOps/functions/confirm_discard.md) — Confirm discarding unsaved changes; returns true if accepted.
- [`func _show_info(msg: String) -> void`](ScenarioEditorFileOps/functions/_show_info.md) — Show a non-blocking info toast/dialog with a message.
- [`func mark_dirty() -> void`](ScenarioEditorFileOps/functions/mark_dirty.md) — Mark scenario as dirty (has unsaved changes).
- [`func is_dirty() -> bool`](ScenarioEditorFileOps/functions/is_dirty.md) — Check if scenario has unsaved changes.

## Public Attributes

- `ScenarioEditor editor` — Reference to parent ScenarioEditor
- `FileDialog open_dlg` — File dialog for opening scenarios
- `FileDialog save_dlg` — File dialog for saving scenarios

## Member Function Documentation

### init

```gdscript
func init(parent: ScenarioEditor) -> void
```

Initialize with parent editor reference.
`parent` Parent ScenarioEditor instance.

### _init_file_dialogs

```gdscript
func _init_file_dialogs() -> void
```

Create and configure FileDialog instances.

### cmd_save

```gdscript
func cmd_save() -> void
```

Save to current path or fallback to Save As.

### cmd_save_as

```gdscript
func cmd_save_as() -> void
```

Show Save As dialog with suggested filename.

### cmd_open

```gdscript
func cmd_open() -> void
```

Show Open dialog (asks to discard if dirty).

### _on_open_file_selected

```gdscript
func _on_open_file_selected(path: String) -> void
```

Handle file selection to open a scenario.
`path` File path selected.

### _on_save_file_selected

```gdscript
func _on_save_file_selected(path: String) -> void
```

Handle file selection to save a scenario.
`path` File path selected.

### on_new_scenario

```gdscript
func on_new_scenario(d: ScenarioData) -> void
```

Apply brand-new scenario data from dialog.
`d` New scenario data.

### confirm_discard

```gdscript
func confirm_discard() -> bool
```

Confirm discarding unsaved changes; returns true if accepted.
[return] True if user confirmed discard.

### _show_info

```gdscript
func _show_info(msg: String) -> void
```

Show a non-blocking info toast/dialog with a message.
`msg` Message to display.

### mark_dirty

```gdscript
func mark_dirty() -> void
```

Mark scenario as dirty (has unsaved changes).

### is_dirty

```gdscript
func is_dirty() -> bool
```

Check if scenario has unsaved changes.
[return] True if dirty.

## Member Data Documentation

### editor

```gdscript
var editor: ScenarioEditor
```

Reference to parent ScenarioEditor

### open_dlg

```gdscript
var open_dlg: FileDialog
```

File dialog for opening scenarios

### save_dlg

```gdscript
var save_dlg: FileDialog
```

File dialog for saving scenarios
