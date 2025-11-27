# DebugMenuMission::refresh Function Reference

*Defined at:* `scripts/ui/DebugMenuMission.gd` (lines 18–130)</br>
*Belongs to:* [DebugMenuMission](../../DebugMenuMission.md)

**Signature**

```gdscript
func refresh(parent: Node) -> void
```

## Description

Refresh the mission debug UI with current mission data

## Source

```gdscript
func refresh(parent: Node) -> void:
	for child in mission_content.get_children():
		child.queue_free()

	# Find SimWorld in the scene tree
	var sim_world: Node = _find_sim_world(parent)
	if not sim_world:
		mission_status.text = "No active mission"
		var label := Label.new()
		label.text = "No mission running. Start a mission from HQ Table."
		mission_content.add_child(label)
		return

	# Check if we have a scenario with objectives
	var scenario: ScenarioData = sim_world.get("_scenario")
	if not scenario:
		mission_status.text = "Mission loading..."
		var label := Label.new()
		label.text = "Mission is loading..."
		mission_content.add_child(label)
		return

	mission_status.text = "Mission: %s" % scenario.title
	mission_content.columns = 2

	# Check if scenario has objectives in briefing
	var objectives: Array = []
	if scenario.briefing and scenario.briefing.frag_objectives:
		objectives = scenario.briefing.frag_objectives

	if objectives.is_empty():
		var label := Label.new()
		label.text = "No objectives defined for this mission"
		mission_content.add_child(label)
		mission_content.add_child(Control.new())  # Empty cell for grid
		return

	# Add objective controls section
	_add_separator()

	var objectives_header := Label.new()
	objectives_header.text = "Objective Controls (%d)" % objectives.size()
	objectives_header.add_theme_font_size_override("font_size", 14)
	objectives_header.add_theme_color_override("font_color", Color.YELLOW)
	mission_content.add_child(objectives_header)
	mission_content.add_child(Control.new())  # Empty cell for grid

	# Add buttons for each objective
	for obj in objectives:
		if not obj or not obj.id:
			continue

		var obj_title: String = obj.title if obj.title != "" else obj.id
		var obj_id: String = obj.id

		# Get current state
		var current_state := _get_objective_state(obj_id)
		var state_text := ""
		match current_state:
			0:
				state_text = "PENDING"
			1:
				state_text = "SUCCESS"
			2:
				state_text = "FAILED"
			_:
				state_text = "UNKNOWN"

		# Objective label with current state
		var obj_label := Label.new()
		obj_label.text = "%s [%s]" % [obj_title, state_text]
		obj_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		mission_content.add_child(obj_label)

		# Buttons row
		var buttons_hbox := HBoxContainer.new()
		buttons_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		mission_content.add_child(buttons_hbox)

		# Success button
		var success_btn := Button.new()
		success_btn.text = "Complete"
		success_btn.disabled = current_state == 1
		success_btn.pressed.connect(
			func():
				_set_objective_state(obj_id, 1)
				refresh(parent)
		)
		buttons_hbox.add_child(success_btn)

		# Fail button
		var fail_btn := Button.new()
		fail_btn.text = "Fail"
		fail_btn.disabled = current_state == 2
		fail_btn.pressed.connect(
			func():
				_set_objective_state(obj_id, 2)
				refresh(parent)
		)
		buttons_hbox.add_child(fail_btn)

		# Reset button
		var reset_btn := Button.new()
		reset_btn.text = "Reset"
		reset_btn.disabled = current_state == 0
		reset_btn.pressed.connect(
			func():
				_set_objective_state(obj_id, 0)
				refresh(parent)
		)
		buttons_hbox.add_child(reset_btn)
```
