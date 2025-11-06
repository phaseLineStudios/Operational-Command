# ScenarioEditorDeletionOps::delete_trigger Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorDeletionOps.gd` (lines 191–206)</br>
*Belongs to:* [ScenarioEditorDeletionOps](../../ScenarioEditorDeletionOps.md)

**Signature**

```gdscript
func delete_trigger(trigger_index: int) -> void
```

- **trigger_index**: Index of trigger to delete.

## Description

Delete a trigger; push history and refresh.

## Source

```gdscript
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
```
