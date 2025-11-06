# ScenarioEditorDeletionOps::delete_task Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorDeletionOps.gd` (lines 131–188)</br>
*Belongs to:* [ScenarioEditorDeletionOps](../../ScenarioEditorDeletionOps.md)

**Signature**

```gdscript
func delete_task(task_index: int) -> void
```

- **task_index**: Index of task to delete.

## Description

Delete a task; repair chain links and reindex; push history.

## Source

```gdscript
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
```
