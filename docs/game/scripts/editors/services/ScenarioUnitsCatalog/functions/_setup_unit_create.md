# ScenarioUnitsCatalog::_setup_unit_create Function Reference

*Defined at:* `scripts/editors/services/ScenarioUnitsCatalog.gd` (lines 137–144)</br>
*Belongs to:* [ScenarioUnitsCatalog](../../ScenarioUnitsCatalog.md)

**Signature**

```gdscript
func _setup_unit_create(ctx: ScenarioEditorContext)
```

## Source

```gdscript
func _setup_unit_create(ctx: ScenarioEditorContext):
	if not ctx.unit_create_btn.pressed.is_connected(func(): _on_create_pressed(ctx)):
		ctx.unit_create_btn.pressed.connect(func(): _on_create_pressed(ctx))

	if not ctx.unit_create_dlg.unit_saved.is_connected(func(u, p): _on_unit_saved(ctx, u, p)):
		ctx.unit_create_dlg.unit_saved.connect(func(u, p): _on_unit_saved(ctx, u, p))
```
