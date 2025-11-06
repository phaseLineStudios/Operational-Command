# ScenarioEditorFileOps::_init_file_dialogs Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorFileOps.gd` (lines 32–49)</br>
*Belongs to:* [ScenarioEditorFileOps](../../ScenarioEditorFileOps.md)

**Signature**

```gdscript
func _init_file_dialogs() -> void
```

## Description

Create and configure FileDialog instances.

## Source

```gdscript
func _init_file_dialogs() -> void:
	open_dlg = FileDialog.new()
	open_dlg.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	open_dlg.access = FileDialog.ACCESS_FILESYSTEM
	open_dlg.filters = ScenarioPersistenceService.JSON_FILTER
	open_dlg.title = "Open Scenario"
	open_dlg.file_selected.connect(_on_open_file_selected)
	editor.add_child(open_dlg)

	save_dlg = FileDialog.new()
	save_dlg.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	save_dlg.access = FileDialog.ACCESS_FILESYSTEM
	save_dlg.filters = ScenarioPersistenceService.JSON_FILTER
	save_dlg.title = "Save Scenario As"
	save_dlg.file_selected.connect(_on_save_file_selected)
	editor.add_child(save_dlg)
```
