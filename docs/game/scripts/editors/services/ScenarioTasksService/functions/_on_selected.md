# ScenarioTasksService::_on_selected Function Reference

*Defined at:* `scripts/editors/services/ScenarioTasksService.gd` (lines 38–44)</br>
*Belongs to:* [ScenarioTasksService](../../ScenarioTasksService.md)

**Signature**

```gdscript
func _on_selected(ctx: ScenarioEditorContext, index: int) -> void
```

## Source

```gdscript
func _on_selected(ctx: ScenarioEditorContext, index: int) -> void:
	var meta: Variant = ctx.task_list.get_item_metadata(index)
	selected_def = meta if meta is UnitBaseTask else null
	if selected_def:
		ctx.selection_changed.emit({"type": &"task_palette", "task": selected_def})
```
