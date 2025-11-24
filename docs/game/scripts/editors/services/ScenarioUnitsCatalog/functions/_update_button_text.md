# ScenarioUnitsCatalog::_update_button_text Function Reference

*Defined at:* `scripts/editors/services/ScenarioUnitsCatalog.gd` (lines 200–207)</br>
*Belongs to:* [ScenarioUnitsCatalog](../../ScenarioUnitsCatalog.md)

**Signature**

```gdscript
func _update_button_text(ctx: ScenarioEditorContext) -> void
```

## Description

Update the create/edit button text based on current selection

## Source

```gdscript
func _update_button_text(ctx: ScenarioEditorContext) -> void:
	var sel := _get_selected_unit(ctx)
	if sel != null:
		ctx.unit_create_btn.text = "* Edit Unit"
	else:
		ctx.unit_create_btn.text = "+ New Unit"
```
