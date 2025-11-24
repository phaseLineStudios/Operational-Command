# ScenarioUnitsCatalog::_deselect_unit Function Reference

*Defined at:* `scripts/editors/services/ScenarioUnitsCatalog.gd` (lines 209–215)</br>
*Belongs to:* [ScenarioUnitsCatalog](../../ScenarioUnitsCatalog.md)

**Signature**

```gdscript
func _deselect_unit(ctx: ScenarioEditorContext) -> void
```

## Description

Deselect the currently selected unit in the tree

## Source

```gdscript
func _deselect_unit(ctx: ScenarioEditorContext) -> void:
	var selected_item := ctx.unit_list.get_selected()
	if selected_item:
		selected_item.deselect(0)
	_update_button_text(ctx)
```
