# ScenarioUnitsCatalog::_build_categories Function Reference

*Defined at:* `scripts/editors/services/ScenarioUnitsCatalog.gd` (lines 19–44)</br>
*Belongs to:* [ScenarioUnitsCatalog](../../ScenarioUnitsCatalog.md)

**Signature**

```gdscript
func _build_categories(ctx: ScenarioEditorContext) -> void
```

## Source

```gdscript
func _build_categories(ctx: ScenarioEditorContext) -> void:
	var opt := ctx.unit_category_opt
	opt.clear()
	for i in unit_categories.size():
		var cat := unit_categories[i]
		opt.add_item(cat.title, i)
		var icon := cat.editor_icon
		var img := icon.get_image()
		img.resize(24, 24, Image.INTERPOLATE_LANCZOS)
		opt.set_item_icon(i, ImageTexture.create_from_image(img))
	selected_category = unit_categories[0]
	opt.item_selected.connect(
		func(idx):
			selected_category = unit_categories[idx]
			_refresh(ctx)
	)

	ctx.unit_search.text_changed.connect(func(_t): _refresh(ctx))
	ctx.unit_faction_friend.pressed.connect(
		func(): _set_faction(ctx, ScenarioUnit.Affiliation.FRIEND)
	)
	ctx.unit_faction_enemy.pressed.connect(
		func(): _set_faction(ctx, ScenarioUnit.Affiliation.ENEMY)
	)
```
