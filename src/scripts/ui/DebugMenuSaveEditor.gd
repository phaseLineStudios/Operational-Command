class_name DebugMenuSaveEditor
extends RefCounted
## Save editor functionality for debug menu.
##
## Handles the UI and logic for editing campaign save files in the debug menu.

var save_editor_save_name: Label
var save_editor_content: GridContainer


func _init(save_name_label: Label, content_grid: GridContainer) -> void:
	save_editor_save_name = save_name_label
	save_editor_content = content_grid


## Refresh the save editor UI with current save data
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


## Add a text field row to save editor
func _add_row(label_text: String, value: String, callback: Callable) -> void:
	var label := Label.new()
	label.text = label_text + ":"
	label.custom_minimum_size.x = 150
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	save_editor_content.add_child(label)

	if callback.is_null():
		var value_label := Label.new()
		value_label.text = value
		value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		save_editor_content.add_child(value_label)
	else:
		var line_edit := LineEdit.new()
		line_edit.text = value
		line_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		line_edit.text_submitted.connect(callback)
		save_editor_content.add_child(line_edit)


## Add an integer field row to save editor
func _add_row_int(label_text: String, value: int, callback: Callable) -> void:
	var label := Label.new()
	label.text = label_text + ":"
	label.custom_minimum_size.x = 150
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	save_editor_content.add_child(label)

	var spinbox := SpinBox.new()
	spinbox.value = float(value)
	spinbox.min_value = 0.0
	spinbox.max_value = 99999.0
	spinbox.step = 1.0
	spinbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spinbox.value_changed.connect(callback)
	save_editor_content.add_child(spinbox)


## Add a separator row
func _add_separator() -> void:
	var separator1 := HSeparator.new()
	separator1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	save_editor_content.add_child(separator1)
	var separator2 := HSeparator.new()
	separator2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	save_editor_content.add_child(separator2)


## Show dialog to add a completed mission
func show_add_mission_dialog(parent: Node, save: CampaignSave) -> void:
	var dialog := AcceptDialog.new()
	dialog.title = "Add Completed Mission"
	dialog.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	parent.add_child(dialog)

	var vbox := VBoxContainer.new()
	dialog.add_child(vbox)

	var info_label := Label.new()
	info_label.text = "Campaign: %s" % save.campaign_id
	info_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(info_label)

	var label := Label.new()
	label.text = "Select mission to mark as completed:"
	vbox.add_child(label)

	var item_list := ItemList.new()
	item_list.custom_minimum_size = Vector2(400, 300)
	vbox.add_child(item_list)

	var campaign: CampaignData = ContentDB.get_campaign(save.campaign_id)
	var scenarios: Array[ScenarioData] = ContentDB.list_scenarios_for_campaign(save.campaign_id)
	var total_scenarios := 0
	if campaign:
		total_scenarios = scenarios.size()
		for scenario in scenarios:
			if scenario and scenario.id not in save.completed_missions:
				var display_text := "%s - %s" % [scenario.id, scenario.title]
				item_list.add_item(display_text)
				item_list.set_item_metadata(item_list.item_count - 1, scenario.id)

	var status_label := Label.new()
	if not campaign:
		status_label.text = "ERROR: Campaign '%s' not found in ContentDB" % save.campaign_id
		status_label.add_theme_color_override("font_color", Color.RED)
	elif total_scenarios == 0:
		status_label.text = "Campaign has no scenarios"
		status_label.add_theme_color_override("font_color", Color.YELLOW)
	elif item_list.item_count == 0:
		status_label.text = "All %d missions already completed" % total_scenarios
		status_label.add_theme_color_override("font_color", Color.YELLOW)
	else:
		status_label.text = (
			"%d available / %d completed / %d total"
			% [item_list.item_count, save.completed_missions.size(), total_scenarios]
		)
		status_label.add_theme_color_override("font_color", Color.GREEN)
	vbox.add_child(status_label)

	if item_list.item_count == 0:
		dialog.get_ok_button().disabled = true

	dialog.confirmed.connect(
		func():
			var selected := item_list.get_selected_items()
			if selected.size() > 0:
				var mission_id: String = item_list.get_item_metadata(selected[0])
				if mission_id not in save.completed_missions:
					save.completed_missions.append(mission_id)
					Persistence.save_to_file(save)
					refresh(parent)
			dialog.queue_free()
	)

	dialog.canceled.connect(func(): dialog.queue_free())
	dialog.popup_centered()


## Show dialog to edit unit state
func show_unit_state_dialog(
	parent: Node, save: CampaignSave, unit_id: String, state: Dictionary
) -> void:
	var dialog := AcceptDialog.new()
	dialog.title = "Edit Unit State: " + unit_id
	dialog.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	parent.add_child(dialog)

	var grid := GridContainer.new()
	grid.columns = 2
	dialog.add_child(grid)

	var controls := {}

	# Strength
	var strength_label := Label.new()
	strength_label.text = "Strength:"
	grid.add_child(strength_label)
	var strength_spin := SpinBox.new()
	strength_spin.value = state.get("state_strength", 0.0)
	strength_spin.min_value = 0.0
	strength_spin.max_value = 999.0
	strength_spin.step = 1.0
	strength_spin.custom_minimum_size = Vector2(200, 0)
	grid.add_child(strength_spin)
	controls["state_strength"] = strength_spin

	# Injured
	var injured_label := Label.new()
	injured_label.text = "Injured:"
	grid.add_child(injured_label)
	var injured_spin := SpinBox.new()
	injured_spin.value = state.get("state_injured", 0.0)
	injured_spin.min_value = 0.0
	injured_spin.max_value = 999.0
	injured_spin.step = 1.0
	grid.add_child(injured_spin)
	controls["state_injured"] = injured_spin

	# Equipment
	var equipment_label := Label.new()
	equipment_label.text = "Equipment:"
	grid.add_child(equipment_label)
	var equipment_spin := SpinBox.new()
	equipment_spin.value = state.get("state_equipment", 1.0)
	equipment_spin.min_value = 0.0
	equipment_spin.max_value = 1.0
	equipment_spin.step = 0.01
	grid.add_child(equipment_spin)
	controls["state_equipment"] = equipment_spin

	# Cohesion
	var cohesion_label := Label.new()
	cohesion_label.text = "Cohesion:"
	grid.add_child(cohesion_label)
	var cohesion_spin := SpinBox.new()
	cohesion_spin.value = state.get("cohesion", 1.0)
	cohesion_spin.min_value = 0.0
	cohesion_spin.max_value = 1.0
	cohesion_spin.step = 0.01
	grid.add_child(cohesion_spin)
	controls["cohesion"] = cohesion_spin

	dialog.confirmed.connect(
		func():
			state["state_strength"] = controls["state_strength"].value
			state["state_injured"] = controls["state_injured"].value
			state["state_equipment"] = controls["state_equipment"].value
			state["cohesion"] = controls["cohesion"].value
			save.unit_states[unit_id] = state
			Persistence.save_to_file(save)
			refresh(parent)
			dialog.queue_free()
	)

	dialog.canceled.connect(func(): dialog.queue_free())
	dialog.popup_centered()


## Show dialog to add a new unit state
func show_add_unit_state_dialog(parent: Node, save: CampaignSave) -> void:
	var dialog := AcceptDialog.new()
	dialog.title = "Add New Unit State"
	dialog.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	parent.add_child(dialog)

	var grid := GridContainer.new()
	grid.columns = 2
	dialog.add_child(grid)

	var controls := {}

	# Unit ID
	var id_label := Label.new()
	id_label.text = "Unit ID:"
	grid.add_child(id_label)
	var id_edit := LineEdit.new()
	id_edit.placeholder_text = "Enter unit ID"
	id_edit.custom_minimum_size = Vector2(200, 0)
	grid.add_child(id_edit)
	controls["unit_id"] = id_edit

	# Strength
	var strength_label := Label.new()
	strength_label.text = "Strength:"
	grid.add_child(strength_label)
	var strength_spin := SpinBox.new()
	strength_spin.value = 100.0
	strength_spin.min_value = 0.0
	strength_spin.max_value = 999.0
	strength_spin.step = 1.0
	strength_spin.custom_minimum_size = Vector2(200, 0)
	grid.add_child(strength_spin)
	controls["state_strength"] = strength_spin

	# Injured
	var injured_label := Label.new()
	injured_label.text = "Injured:"
	grid.add_child(injured_label)
	var injured_spin := SpinBox.new()
	injured_spin.value = 0.0
	injured_spin.min_value = 0.0
	injured_spin.max_value = 999.0
	injured_spin.step = 1.0
	grid.add_child(injured_spin)
	controls["state_injured"] = injured_spin

	# Equipment
	var equipment_label := Label.new()
	equipment_label.text = "Equipment:"
	grid.add_child(equipment_label)
	var equipment_spin := SpinBox.new()
	equipment_spin.value = 1.0
	equipment_spin.min_value = 0.0
	equipment_spin.max_value = 1.0
	equipment_spin.step = 0.01
	grid.add_child(equipment_spin)
	controls["state_equipment"] = equipment_spin

	# Cohesion
	var cohesion_label := Label.new()
	cohesion_label.text = "Cohesion:"
	grid.add_child(cohesion_label)
	var cohesion_spin := SpinBox.new()
	cohesion_spin.value = 1.0
	cohesion_spin.min_value = 0.0
	cohesion_spin.max_value = 1.0
	cohesion_spin.step = 0.01
	grid.add_child(cohesion_spin)
	controls["cohesion"] = cohesion_spin

	dialog.confirmed.connect(
		func():
			var unit_id: String = controls["unit_id"].text.strip_edges()
			if unit_id == "":
				dialog.queue_free()
				return

			var new_state: Dictionary = {
				"state_strength": controls["state_strength"].value,
				"state_injured": controls["state_injured"].value,
				"state_equipment": controls["state_equipment"].value,
				"cohesion": controls["cohesion"].value
			}
			save.unit_states[unit_id] = new_state
			Persistence.save_to_file(save)
			refresh(parent)
			dialog.queue_free()
	)

	dialog.canceled.connect(func(): dialog.queue_free())
	dialog.popup_centered()


## Show dialog to select current mission from campaign
func show_select_current_mission_dialog(
	parent: Node, save: CampaignSave, line_edit: LineEdit
) -> void:
	var dialog := AcceptDialog.new()
	dialog.title = "Select Current Mission"
	dialog.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	parent.add_child(dialog)

	var vbox := VBoxContainer.new()
	dialog.add_child(vbox)

	var label := Label.new()
	label.text = "Select mission to set as current:"
	vbox.add_child(label)

	var item_list := ItemList.new()
	item_list.custom_minimum_size = Vector2(400, 300)
	vbox.add_child(item_list)

	var campaign: CampaignData = ContentDB.get_campaign(save.campaign_id)
	var scenarios: Array[ScenarioData] = ContentDB.list_scenarios_for_campaign(save.campaign_id)
	if campaign:
		for scenario in scenarios:
			if scenario:
				var display_text := "%s - %s" % [scenario.id, scenario.title]
				item_list.add_item(display_text)
				item_list.set_item_metadata(item_list.item_count - 1, scenario.id)

	if item_list.item_count == 0:
		var no_missions_label := Label.new()
		no_missions_label.text = "No missions found in campaign"
		no_missions_label.add_theme_color_override("font_color", Color.YELLOW)
		vbox.add_child(no_missions_label)
		dialog.get_ok_button().disabled = true
	else:
		for i in range(item_list.item_count):
			if item_list.get_item_metadata(i) == save.current_mission:
				item_list.select(i)
				break

	dialog.confirmed.connect(
		func():
			var selected := item_list.get_selected_items()
			if selected.size() > 0:
				var mission_id: String = item_list.get_item_metadata(selected[0])
				save.current_mission = mission_id
				line_edit.text = mission_id
				Persistence.save_to_file(save)
				refresh(parent)
			dialog.queue_free()
	)

	dialog.canceled.connect(func(): dialog.queue_free())
	dialog.popup_centered()
