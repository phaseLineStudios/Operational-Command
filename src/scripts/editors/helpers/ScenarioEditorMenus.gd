class_name ScenarioEditorMenus
extends RefCounted
## Helper for managing menus and dialogs in the Scenario Editor.
##
## Handles menu button actions (File, Attributes) and opening configuration dialogs
## for slots, units, tasks, triggers, and custom commands.

## Path to return to main menu scene
const MAIN_MENU_SCENE := "res://scenes/main_menu.tscn"

## Reference to parent ScenarioEditor
var editor: ScenarioEditor


## Initialize with parent editor reference.
## [param parent] Parent ScenarioEditor instance.
func init(parent: ScenarioEditor) -> void:
	editor = parent


## Handle File menu actions (New/Open/Save/Save As/Back).
## [param id] Menu item ID.
func on_filemenu_pressed(id: int) -> void:
	match id:
		0:
			editor.new_scenario_dialog.show_dialog(true)
		1:
			editor.file_ops.cmd_open()
		2:
			editor.file_ops.cmd_save()
		3:
			editor.file_ops.cmd_save_as()
		4:
			Game.goto_scene(MAIN_MENU_SCENE)


## Handle Attributes menu actions (Edit Scenario/Briefing/Weather).
## [param id] Menu item ID.
func on_attributemenu_pressed(id: int) -> void:
	match id:
		0:
			if editor.ctx.data:
				editor.new_scenario_dialog.show_dialog(true, editor.ctx.data)
			else:
				editor.new_scenario_dialog.show_dialog(true)
		1:
			if editor.ctx.data == null:
				var acc := AcceptDialog.new()
				acc.title = "Briefing"
				acc.dialog_text = "Create a scenario first."
				editor.add_child(acc)
				acc.popup_centered()
				return
			editor.brief_dialog.show_dialog(true, editor.ctx.data.briefing)
		2:
			if editor.ctx.data == null:
				var acc := AcceptDialog.new()
				acc.title = "Weather"
				acc.dialog_text = "Create a scenario first."
				editor.add_child(acc)
				acc.popup_centered()
				return
			editor.weather_dialog.show_dialog(true)


## Open slot configuration dialog for a slot index.
## [param index] Slot index.
func open_slot_config(index: int) -> void:
	if not editor.ctx.data or not editor.ctx.data.unit_slots:
		return
	editor.slot_cfg.show_for(editor, index)


## Open unit configuration dialog for a unit index.
## [param index] Unit index.
func open_unit_config(index: int) -> void:
	if not editor.ctx.data or not editor.ctx.data.units:
		return
	editor.unit_cfg.show_for(editor, index)


## Open task configuration dialog for a task index.
## [param task_index] Task index.
func open_task_config(task_index: int) -> void:
	if not editor.ctx.data or editor.ctx.data.tasks == null:
		return
	var inst: ScenarioTask = editor.ctx.data.tasks[task_index]
	editor.task_cfg.show_for(editor, inst)


## Open trigger configuration dialog for a trigger index.
## [param index] Trigger index.
func open_trigger_config(index: int) -> void:
	if index < 0 or index >= editor.ctx.data.triggers.size():
		return
	editor.trigger_cfg.show_for(editor, index)


## Open custom command configuration dialog for a command index.
## [param index] Custom command index.
func open_command_config(index: int) -> void:
	if index < 0 or index >= editor.ctx.data.custom_commands.size():
		return
	editor.command_cfg.show_for(editor, index)
