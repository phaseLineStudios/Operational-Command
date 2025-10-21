# ScenarioEditor::_delete_slot Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 533–548)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _delete_slot(slot_index: int) -> void
```

## Description

Delete a slot; push history and refresh

## Source

```gdscript
func _delete_slot(slot_index: int) -> void:
	if not ctx.data or not ctx.data.unit_slots:
		return
	if slot_index < 0 or slot_index >= ctx.data.unit_slots.size():
		return
	var before := _snapshot_arrays()
	var after := _snapshot_arrays()
	(after["unit_slots"] as Array).remove_at(slot_index)
	history.push_array_replace(
		ctx.data, "unit_slots", before["unit_slots"], after["unit_slots"], "Delete Slot"
	)
	selection.clear_selection(ctx)
	ctx.request_overlay_redraw()
	_rebuild_scene_tree()
```
