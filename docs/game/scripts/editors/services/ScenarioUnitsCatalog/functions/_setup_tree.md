# ScenarioUnitsCatalog::_setup_tree Function Reference

*Defined at:* `scripts/editors/services/ScenarioUnitsCatalog.gd` (lines 52–59)</br>
*Belongs to:* [ScenarioUnitsCatalog](../../ScenarioUnitsCatalog.md)

**Signature**

```gdscript
func _setup_tree(ctx: ScenarioEditorContext) -> void
```

## Source

```gdscript
func _setup_tree(ctx: ScenarioEditorContext) -> void:
	var list := ctx.unit_list
	list.set_column_expand(0, true)
	list.set_column_custom_minimum_width(0, 200)
	if not list.item_selected.is_connected(func(): _on_tree_item(ctx)):
		list.item_selected.connect(func(): _on_tree_item(ctx))
```
