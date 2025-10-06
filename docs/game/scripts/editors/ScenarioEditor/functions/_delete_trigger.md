# ScenarioEditor::_delete_trigger Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 608–623)</br>
*Belongs to:* [ScenarioEditor](../ScenarioEditor.md)

**Signature**

```gdscript
func _delete_trigger(trigger_index: int) -> void
```

## Description

Delete a trigger; push history and refresh

## Source

```gdscript
func _delete_trigger(trigger_index: int) -> void:
	if not ctx.data or not ctx.data.triggers:
		return
	if trigger_index < 0 or trigger_index >= ctx.data.triggers.size():
		return
	var before := _snapshot_arrays()
	var after := _snapshot_arrays()
	(after["triggers"] as Array).remove_at(trigger_index)
	history.push_array_replace(
		ctx.data, "triggers", before["triggers"], after["triggers"], "Delete Trigger"
	)
	selection.clear_selection(ctx)
	ctx.request_overlay_redraw()
	_rebuild_scene_tree()
```
