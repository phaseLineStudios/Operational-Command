# ScenarioEditor::_init_file_dialogs Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 176–193)</br>
*Belongs to:* [ScenarioEditor](../ScenarioEditor.md)

**Signature**

```gdscript
func _init_file_dialogs() -> void
```

## Description

Create and configure FileDialog instances

## Source

```gdscript
func _init_file_dialogs() -> void:
	_open_dlg = FileDialog.new()
	_open_dlg.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	_open_dlg.access = FileDialog.ACCESS_FILESYSTEM
	_open_dlg.filters = ScenarioPersistenceService.JSON_FILTER
	_open_dlg.title = "Open Scenario"
	_open_dlg.file_selected.connect(_on_open_file_selected)
	add_child(_open_dlg)

	_save_dlg = FileDialog.new()
	_save_dlg.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	_save_dlg.access = FileDialog.ACCESS_FILESYSTEM
	_save_dlg.filters = ScenarioPersistenceService.JSON_FILTER
	_save_dlg.title = "Save Scenario As"
	_save_dlg.file_selected.connect(_on_save_file_selected)
	add_child(_save_dlg)
```
