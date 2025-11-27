# DebugMenuSaveEditor::show_add_mission_dialog Function Reference

*Defined at:* `scripts/ui/DebugMenuSaveEditor.gd` (lines 209–278)</br>
*Belongs to:* [DebugMenuSaveEditor](../../DebugMenuSaveEditor.md)

**Signature**

```gdscript
func show_add_mission_dialog(parent: Node, save: CampaignSave) -> void
```

## Description

Show dialog to add a completed mission

## Source

```gdscript
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
```
