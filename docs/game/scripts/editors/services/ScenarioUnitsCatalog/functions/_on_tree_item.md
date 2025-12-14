# ScenarioUnitsCatalog::_on_tree_item Function Reference

*Defined at:* `scripts/editors/services/ScenarioUnitsCatalog.gd` (lines 61–71)</br>
*Belongs to:* [ScenarioUnitsCatalog](../../ScenarioUnitsCatalog.md)

**Signature**

```gdscript
func _on_tree_item(ctx: ScenarioEditorContext) -> void
```

## Source

```gdscript
func _on_tree_item(ctx: ScenarioEditorContext) -> void:
	var it := ctx.unit_list.get_selected()
	if it == null:
		return
	var payload: Variant = it.get_metadata(0)
	if payload is UnitData or payload is UnitSlotData:
		ctx.selection_changed.emit({"type": &"palette", "payload": payload})
	# Update button text when selection changes
	_update_button_text(ctx)
```
