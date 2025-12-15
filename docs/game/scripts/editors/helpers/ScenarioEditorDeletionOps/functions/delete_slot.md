# ScenarioEditorDeletionOps::delete_slot Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorDeletionOps.gd` (lines 114–130)</br>
*Belongs to:* [ScenarioEditorDeletionOps](../../ScenarioEditorDeletionOps.md)

**Signature**

```gdscript
func delete_slot(slot_index: int) -> void
```

- **slot_index**: Index of slot to delete.

## Description

Delete a slot; push history and refresh.

## Source

```gdscript
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
	editor.generic_notification("Deleted slot", 1, false)
```
