# TaskPlaceTool::_place Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTaskTool.gd` (lines 73–104)</br>
*Belongs to:* [TaskPlaceTool](../TaskPlaceTool.md)

**Signature**

```gdscript
func _place() -> void
```

## Source

```gdscript
func _place() -> void:
	if not editor or not editor.ctx:
		return
	if editor.ctx.selected_pick.is_empty():
		editor.ctx.toast("Select a unit or a task first.")
		return

	var unit_idx := -1
	var after_idx := -1

	match String(editor.ctx.selected_pick.get("type", "")):
		"unit":
			unit_idx = int(editor.ctx.selected_pick["index"])
		"task":
			after_idx = int(editor.ctx.selected_pick["index"])
			var sel: ScenarioTask = editor.ctx.data.tasks[after_idx]
			if sel == null:
				editor.ctx.toast("Selected task is invalid.")
				return
			unit_idx = sel.unit_index
		_:
			editor.ctx.toast("Select a unit or a task first.")
			return

	var new_idx := editor.tasks.place_task_for_unit(
		editor.ctx, unit_idx, task, _hover_map_pos, after_idx
	)
	if new_idx < 0:
		return
	emit_signal("request_redraw_overlay")
```
