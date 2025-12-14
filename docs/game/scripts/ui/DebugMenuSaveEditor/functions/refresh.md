# DebugMenuSaveEditor::refresh Function Reference

*Defined at:* `scripts/ui/DebugMenuSaveEditor.gd` (lines 17–149)</br>
*Belongs to:* [DebugMenuSaveEditor](../../DebugMenuSaveEditor.md)

**Signature**

```gdscript
func refresh(parent: Node) -> void
```

## Description

Refresh the save editor UI with current save data

## Source

```gdscript
func refresh(parent: Node) -> void:
	for child in save_editor_content.get_children():
		child.queue_free()

	if not Game.current_save:
		save_editor_save_name.text = "No save loaded"
		var label := Label.new()
		label.text = "No save file currently loaded"
		save_editor_content.add_child(label)
		return

	var save := Game.current_save
	save_editor_save_name.text = save.save_name
	save_editor_content.columns = 2

	_add_row(
		"Save Name",
		save.save_name,
		func(value):
			save.save_name = value
			Persistence.save_to_file(save)
			refresh(parent)
	)

	_add_row("Campaign ID", save.campaign_id, Callable())

	var current_mission_label := Label.new()
	current_mission_label.text = "Current Mission:"
	current_mission_label.custom_minimum_size.x = 150
	current_mission_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	save_editor_content.add_child(current_mission_label)

	var current_mission_hbox := HBoxContainer.new()
	current_mission_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	save_editor_content.add_child(current_mission_hbox)

	var current_mission_edit := LineEdit.new()
	current_mission_edit.text = save.current_mission
	current_mission_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	current_mission_edit.placeholder_text = "Enter mission ID or use dropdown"
	current_mission_edit.text_submitted.connect(
		func(value):
			save.current_mission = value
			Persistence.save_to_file(save)
			refresh(parent)
	)
	current_mission_hbox.add_child(current_mission_edit)

	var current_mission_select_btn := Button.new()
	current_mission_select_btn.text = "Select..."
	current_mission_select_btn.pressed.connect(
		func(): show_select_current_mission_dialog(parent, save, current_mission_edit)
	)
	current_mission_hbox.add_child(current_mission_select_btn)

	# Total Playtime (read-only, formatted)
	var hours := int(save.total_playtime_seconds / 3600.0)
	var minutes := int(fmod(save.total_playtime_seconds / 60.0, 60.0))
	_add_row("Playtime", "%dh %dm" % [hours, minutes], Callable())

	# Completed Missions Section
	_add_separator()

	var missions_header := Label.new()
	missions_header.text = "Completed Missions (%d)" % save.completed_missions.size()
	missions_header.add_theme_font_size_override("font_size", 14)
	missions_header.add_theme_color_override("font_color", Color.YELLOW)
	save_editor_content.add_child(missions_header)

	var add_mission_btn := Button.new()
	add_mission_btn.text = "Add Mission"
	add_mission_btn.pressed.connect(func(): show_add_mission_dialog(parent, save))
	save_editor_content.add_child(add_mission_btn)

	for mission_id in save.completed_missions:
		var mission_label := Label.new()
		mission_label.text = mission_id
		mission_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		save_editor_content.add_child(mission_label)

		var remove_btn := Button.new()
		remove_btn.text = "Remove"
		remove_btn.pressed.connect(
			func():
				save.completed_missions.erase(mission_id)
				Persistence.save_to_file(save)
				refresh(parent)
		)
		save_editor_content.add_child(remove_btn)

	# Unit States Section
	_add_separator()

	var unit_states_header := Label.new()
	unit_states_header.text = "Unit States (%d units)" % save.unit_states.size()
	unit_states_header.add_theme_font_size_override("font_size", 14)
	unit_states_header.add_theme_color_override("font_color", Color.YELLOW)
	save_editor_content.add_child(unit_states_header)

	var unit_buttons_hbox := HBoxContainer.new()
	save_editor_content.add_child(unit_buttons_hbox)

	var unit_add_btn := Button.new()
	unit_add_btn.text = "Add Unit State"
	unit_add_btn.pressed.connect(func(): show_add_unit_state_dialog(parent, save))
	unit_buttons_hbox.add_child(unit_add_btn)

	var unit_clear_btn := Button.new()
	unit_clear_btn.text = "Clear All States"
	unit_clear_btn.pressed.connect(
		func():
			save.unit_states.clear()
			Persistence.save_to_file(save)
			refresh(parent)
	)
	unit_buttons_hbox.add_child(unit_clear_btn)

	for unit_id in save.unit_states.keys():
		var state: Dictionary = save.unit_states[unit_id]
		var unit_label := Label.new()
		unit_label.text = (
			"%s (Str: %.0f, Eq: %.0f%%)"
			% [unit_id, state.get("state_strength", 0.0), state.get("state_equipment", 1.0) * 100.0]
		)
		unit_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		save_editor_content.add_child(unit_label)

		var edit_btn := Button.new()
		edit_btn.text = "Edit"
		edit_btn.pressed.connect(func(): show_unit_state_dialog(parent, save, unit_id, state))
		save_editor_content.add_child(edit_btn)
```
