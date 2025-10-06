# ScenarioTriggersService::_on_selected Function Reference

*Defined at:* `scripts/editors/services/ScenarioTriggersService.gd` (lines 19–24)</br>
*Belongs to:* [ScenarioTriggersService](../ScenarioTriggersService.md)

**Signature**

```gdscript
func _on_selected(ctx: ScenarioEditorContext, idx: int) -> void
```

## Source

```gdscript
func _on_selected(ctx: ScenarioEditorContext, idx: int) -> void:
	var meta: Variant = ctx.trigger_list.get_item_metadata(idx)
	if meta is ScenarioTrigger:
		ctx.selection_changed.emit({"type": &"trigger_palette", "prototype": meta})
```
