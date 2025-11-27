# DebugMenuSaveEditor::show_add_unit_state_dialog Function Reference

*Defined at:* `scripts/ui/DebugMenuSaveEditor.gd` (lines 360–453)</br>
*Belongs to:* [DebugMenuSaveEditor](../../DebugMenuSaveEditor.md)

**Signature**

```gdscript
func show_add_unit_state_dialog(parent: Node, save: CampaignSave) -> void
```

## Description

Show dialog to add a new unit state

## Source

```gdscript
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
```
