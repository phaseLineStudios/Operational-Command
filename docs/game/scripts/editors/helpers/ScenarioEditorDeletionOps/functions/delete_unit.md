# ScenarioEditorDeletionOps::delete_unit Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorDeletionOps.gd` (lines 36–111)</br>
*Belongs to:* [ScenarioEditorDeletionOps](../../ScenarioEditorDeletionOps.md)

**Signature**

```gdscript
func delete_unit(unit_index: int) -> void
```

- **unit_index**: Index of unit to delete.

## Description

Delete a unit and all its tasks; reindex references; push history.

## Source

```gdscript
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
	editor.generic_notification("Deleted unit", 1, false)
```
