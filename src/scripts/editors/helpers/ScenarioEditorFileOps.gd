class_name ScenarioEditorFileOps
extends RefCounted
## Helper for managing file operations in the Scenario Editor.
##
## Handles file dialogs, save/open/save-as commands, path tracking,
## dirty flag management, and discard confirmation.

## Reference to parent ScenarioEditor
var editor: ScenarioEditor

## File dialog for opening scenarios
var open_dlg: FileDialog

## File dialog for saving scenarios
var save_dlg: FileDialog

## Current file path (empty if unsaved)
var current_path := ""

## Whether scenario has unsaved changes
var dirty := false


## Initialize with parent editor reference.
## [param parent] Parent ScenarioEditor instance.
func init(parent: ScenarioEditor) -> void:
	editor = parent
	_init_file_dialogs()


## Create and configure FileDialog instances.
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


## Save to current path or fallback to Save As.
func cmd_save() -> void:
	if current_path.strip_edges() == "":
		cmd_save_as()
		return
	if editor.ctx.data == null:
		_show_info("No scenario to save.")
		return
	if editor.persistence.save_to_path(editor.ctx, current_path):
		dirty = false
		_show_info("Saved: %s" % current_path)


## Show Save As dialog with suggested filename.
func cmd_save_as() -> void:
	if editor.ctx.data == null:
		_show_info("No scenario to save.")
		return
	save_dlg.current_file = editor.persistence.suggest_filename(editor.ctx)
	save_dlg.popup_centered_ratio(0.75)


## Show Open dialog (asks to discard if dirty).
func cmd_open() -> void:
	if dirty and not await confirm_discard():
		return
	open_dlg.popup_centered_ratio(0.75)


## Handle file selection to open a scenario.
## [param path] File path selected.
func _on_open_file_selected(path: String) -> void:
	if editor.persistence.load_from_path(editor.ctx, path):
		current_path = path
		dirty = false
		editor._on_data_changed()
	else:
		_show_info("Failed to open: %s" % path)


## Handle file selection to save a scenario.
## [param path] File path selected.
func _on_save_file_selected(path: String) -> void:
	var fixed := editor.persistence.ensure_json_ext(path)
	if editor.persistence.save_to_path(editor.ctx, fixed):
		current_path = fixed
		dirty = false
		_show_info("Saved: %s" % fixed)
	else:
		_show_info("Failed to save: %s" % fixed)


## Apply brand-new scenario data from dialog.
## [param d] New scenario data.
func on_new_scenario(d: ScenarioData) -> void:
	editor.ctx.data = d
	current_path = ""
	dirty = false
	editor._on_data_changed()

	if is_instance_valid(editor.history):
		editor.remove_child(editor.history)
	editor.history = ScenarioHistory.new()
	editor.add_child(editor.history)
	editor.ctx.history = editor.history
	editor.history.history_changed.connect(editor._on_history_changed)


## Confirm discarding unsaved changes; returns true if accepted.
## [return] True if user confirmed discard.
func confirm_discard() -> bool:
	var acc := ConfirmationDialog.new()
	acc.title = "Unsaved changes"
	acc.dialog_text = "You have unsaved changes. Discard and continue?"
	editor.add_child(acc)
	var accepted := false
	@warning_ignore("confusable_capture_reassignment")
	acc.canceled.connect(func(): accepted = false)
	@warning_ignore("confusable_capture_reassignment")
	acc.confirmed.connect(func(): accepted = true)
	acc.popup_centered()
	await acc.confirmed
	acc.queue_free()
	return accepted


## Show a non-blocking info toast/dialog with a message.
## [param msg] Message to display.
func _show_info(msg: String) -> void:
	var d := AcceptDialog.new()
	d.title = "Info"
	d.dialog_text = msg
	editor.add_child(d)


## Mark scenario as dirty (has unsaved changes).
func mark_dirty() -> void:
	dirty = true


## Check if scenario has unsaved changes.
## [return] True if dirty.
func is_dirty() -> bool:
	return dirty
