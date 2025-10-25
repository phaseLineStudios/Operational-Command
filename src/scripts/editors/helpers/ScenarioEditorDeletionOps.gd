class_name ScenarioEditorDeletionOps
extends RefCounted
## Helper for managing deletion operations in the Scenario Editor.
##
## Handles deletion of units, slots, tasks, triggers, and custom commands,
## including reference reindexing, chain link repairs, and history integration.

## Reference to parent ScenarioEditor
var editor: ScenarioEditor


## Initialize with parent editor reference.
## [param parent] Parent ScenarioEditor instance.
func init(parent: ScenarioEditor) -> void:
	editor = parent


## Route deletion to the correct entity handler.
## [param pick] Selection dictionary with "type" and "index".
func delete_pick(pick: Dictionary) -> void:
	match StringName(pick.get("type", "")):
		&"unit":
			delete_unit(int(pick["index"]))
		&"slot":
			delete_slot(int(pick["index"]))
		&"task":
			delete_task(int(pick["index"]))
		&"trigger":
			delete_trigger(int(pick["index"]))
		_:
			pass


## Delete a unit and all its tasks; reindex references; push history.
## [param unit_index] Index of unit to delete.
func delete_unit(unit_index: int) -> void:
	if not editor.ctx.data or not editor.ctx.data.units:
		return
	if unit_index < 0 or unit_index >= editor.ctx.data.units.size():
		return
	var before := _snapshot_arrays()
	var after := _snapshot_arrays()

	after["units"].remove_at(unit_index)

	var to_remove: Array[int] = []
	for i in (after["tasks"] as Array).size():
		var ti: ScenarioTask = (after["tasks"] as Array)[i]
		if ti and ti.unit_index == unit_index:
			to_remove.append(i)
	to_remove.sort()
	for i in range(to_remove.size() - 1, -1, -1):
		var inst: ScenarioTask = (after["tasks"] as Array)[to_remove[i]]
		if inst:
			var p := inst.prev_index
			var n := inst.next_index
			if p >= 0 and p < (after["tasks"] as Array).size():
				var prev: Variant = (after["tasks"] as Array)[p]
				if prev:
					prev.next_index = n
			if n >= 0 and n < (after["tasks"] as Array).size():
				var nxt: Variant = (after["tasks"] as Array)[n]
				if nxt:
					nxt.prev_index = p
		(after["tasks"] as Array).remove_at(to_remove[i])

	for t in after["tasks"] as Array:
		if t == null:
			continue
		if t.unit_index > unit_index:
			t.unit_index -= 1
		t.prev_index = clamp(t.prev_index, -1, (after["tasks"] as Array).size() - 1)
		t.next_index = clamp(t.next_index, -1, (after["tasks"] as Array).size() - 1)

	for trig in after["triggers"] as Array:
		if trig == null:
			continue
		if trig.synced_units != null:
			var outu: Array[int] = []
			for uidx in trig.synced_units:
				if uidx == unit_index:
					continue
				outu.append(uidx - 1 if uidx > unit_index else uidx)
			trig.synced_units = outu
		if trig.synced_tasks != null:
			var outt: Array[int] = []
			for tidx in trig.synced_tasks:
				if tidx >= 0 and tidx < (after["tasks"] as Array).size():
					outt.append(tidx)
			trig.synced_tasks = outt

	(
		editor
		. history
		. push_multi_replace(
			editor.ctx.data,
			[
				{"prop": "units", "before": before["units"], "after": after["units"]},
				{"prop": "tasks", "before": before["tasks"], "after": after["tasks"]},
				{"prop": "triggers", "before": before["triggers"], "after": after["triggers"]},
			],
			"Delete Unit"
		)
	)
	editor.selection.clear_selection(editor.ctx)
	editor.ctx.request_overlay_redraw()
	editor._rebuild_scene_tree()
	editor.units._refresh(editor.ctx)


## Delete a slot; push history and refresh.
## [param slot_index] Index of slot to delete.
func delete_slot(slot_index: int) -> void:
	if not editor.ctx.data or not editor.ctx.data.unit_slots:
		return
	if slot_index < 0 or slot_index >= editor.ctx.data.unit_slots.size():
		return
	var before := _snapshot_arrays()
	var after := _snapshot_arrays()
	(after["unit_slots"] as Array).remove_at(slot_index)
	editor.history.push_array_replace(
		editor.ctx.data, "unit_slots", before["unit_slots"], after["unit_slots"], "Delete Slot"
	)
	editor.selection.clear_selection(editor.ctx)
	editor.ctx.request_overlay_redraw()
	editor._rebuild_scene_tree()


## Delete a task; repair chain links and reindex; push history.
## [param task_index] Index of task to delete.
func delete_task(task_index: int) -> void:
	if not editor.ctx.data or not editor.ctx.data.tasks:
		return
	if task_index < 0 or task_index >= editor.ctx.data.tasks.size():
		return
	var before := _snapshot_arrays()
	var after := _snapshot_arrays()

	var all_tasks := after["tasks"] as Array
	var inst: ScenarioTask = all_tasks[task_index]
	if inst:
		var p := inst.prev_index
		var n := inst.next_index
		if p >= 0 and p < all_tasks.size():
			var prev: Variant = all_tasks[p]
			if prev:
				prev.next_index = n
		if n >= 0 and n < all_tasks.size():
			var nxt: Variant = all_tasks[n]
			if nxt:
				nxt.prev_index = p

	all_tasks.remove_at(task_index)
	for t in all_tasks:
		if t == null:
			continue
		if t.prev_index > task_index:
			t.prev_index -= 1
		if t.next_index > task_index:
			t.next_index -= 1

	for trig in after["triggers"] as Array:
		if trig == null or trig.synced_tasks == null:
			continue
		var out: Array[int] = []
		for i in trig.synced_tasks:
			if i == task_index:
				continue
			out.append(i - 1 if i > task_index else i)
		trig.synced_tasks = out

	(
		editor
		. history
		. push_multi_replace(
			editor.ctx.data,
			[
				{"prop": "tasks", "before": before["tasks"], "after": after["tasks"]},
				{"prop": "triggers", "before": before["triggers"], "after": after["triggers"]},
			],
			"Delete Task"
		)
	)
	editor.selection.clear_selection(editor.ctx)
	editor.ctx.request_overlay_redraw()
	editor._rebuild_scene_tree()


## Delete a trigger; push history and refresh.
## [param trigger_index] Index of trigger to delete.
func delete_trigger(trigger_index: int) -> void:
	if not editor.ctx.data or not editor.ctx.data.triggers:
		return
	if trigger_index < 0 or trigger_index >= editor.ctx.data.triggers.size():
		return
	var before := _snapshot_arrays()
	var after := _snapshot_arrays()
	(after["triggers"] as Array).remove_at(trigger_index)
	editor.history.push_array_replace(
		editor.ctx.data, "triggers", before["triggers"], after["triggers"], "Delete Trigger"
	)
	editor.selection.clear_selection(editor.ctx)
	editor.ctx.request_overlay_redraw()
	editor._rebuild_scene_tree()


## Delete a custom command; push history and refresh.
## [param command_index] Index of custom command to delete.
func delete_command(command_index: int) -> void:
	if not editor.ctx.data or not editor.ctx.data.custom_commands:
		return
	if command_index < 0 or command_index >= editor.ctx.data.custom_commands.size():
		return
	var before := editor.ctx.data.custom_commands.duplicate(true)
	var after := editor.ctx.data.custom_commands.duplicate(true)
	after.remove_at(command_index)
	editor.history.push_array_replace(
		editor.ctx.data, "custom_commands", before, after, "Delete Custom Command"
	)
	editor._rebuild_command_list()


## Deep-copy key arrays for history operations.
## [return] Dictionary with deep copies of units, unit_slots, tasks, and triggers arrays.
func _snapshot_arrays() -> Dictionary:
	return {
		"units":
		ScenarioHistory._deep_copy_array_res(
			editor.ctx.data.units if editor.ctx.data and editor.ctx.data.units else []
		),
		"unit_slots":
		ScenarioHistory._deep_copy_array_res(
			editor.ctx.data.unit_slots if editor.ctx.data and editor.ctx.data.unit_slots else []
		),
		"tasks":
		ScenarioHistory._deep_copy_array_res(
			editor.ctx.data.tasks if editor.ctx.data and editor.ctx.data.tasks else []
		),
		"triggers":
		ScenarioHistory._deep_copy_array_res(
			editor.ctx.data.triggers if editor.ctx.data and editor.ctx.data.triggers else []
		),
	}
