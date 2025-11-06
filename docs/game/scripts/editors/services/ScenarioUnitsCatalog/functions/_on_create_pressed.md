# ScenarioUnitsCatalog::_on_create_pressed Function Reference

*Defined at:* `scripts/editors/services/ScenarioUnitsCatalog.gd` (lines 145–152)</br>
*Belongs to:* [ScenarioUnitsCatalog](../../ScenarioUnitsCatalog.md)

**Signature**

```gdscript
func _on_create_pressed(ctx: ScenarioEditorContext) -> void
```

## Source

```gdscript
func _on_create_pressed(ctx: ScenarioEditorContext) -> void:
	var sel = _get_selected_unit(ctx)
	if sel == null:
		ctx.unit_create_dlg.show_dialog(true, null)
	else:
		ctx.unit_create_dlg.show_dialog(true, sel)
```
