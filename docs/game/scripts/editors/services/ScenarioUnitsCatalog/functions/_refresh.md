# ScenarioUnitsCatalog::_refresh Function Reference

*Defined at:* `scripts/editors/services/ScenarioUnitsCatalog.gd` (lines 70–136)</br>
*Belongs to:* [ScenarioUnitsCatalog](../../ScenarioUnitsCatalog.md)

**Signature**

```gdscript
func _refresh(ctx: ScenarioEditorContext) -> void
```

## Source

```gdscript
func _refresh(ctx: ScenarioEditorContext) -> void:
	var list := ctx.unit_list
	list.clear()
	var root := list.create_item()

	var used := _used_unit_ids(ctx)
	var query := ctx.unit_search.text.strip_edges().to_lower()
	var role_items := {}

	var show_slot := query.is_empty() or "slot".findn(query) != -1 or "playable".findn(query) != -1
	if show_slot:
		var pitem := list.create_item(root)
		pitem.set_text(0, "PLAYABLE")
		pitem.set_selectable(0, false)
		var icon := load("res://assets/textures/units/slot_icon.png") as Texture2D
		var img := icon.get_image()
		img.resize(24, 24, Image.INTERPOLATE_LANCZOS)
		var item := list.create_item(pitem)
		item.set_text(0, slot_proto.title)
		item.set_icon(0, ImageTexture.create_from_image(img))
		item.set_metadata(0, slot_proto)

	for unit in all_units:
		if used.has(String(unit.id)):
			continue
		if unit.unit_category.id != selected_category.id:
			continue
		var text_ok := (
			query.is_empty()
			or unit.title.to_lower().find(query) >= 0
			or unit.id.to_lower().find(query) >= 0
		)
		if not text_ok:
			continue

		var role_key := unit.role
		var role_item: TreeItem = role_items.get(role_key)
		if role_item == null:
			role_item = list.create_item(root)
			role_item.set_text(0, role_key)
			role_item.set_selectable(0, false)
			role_items[role_key] = role_item

		var icon := (
			unit.icon
			if ctx.selected_unit_affiliation == ScenarioUnit.Affiliation.FRIEND
			else unit.enemy_icon
		)
		if icon == null:
			icon = (
				load(
					(
						"res://assets/textures/units/nato_unknown_platoon.png"
						if ctx.selected_unit_affiliation == ScenarioUnit.Affiliation.FRIEND
						else "res://assets/textures/units/enemy_unknown_platoon.png"
					)
				)
				as Texture2D
			)
		var img := icon.get_image()
		img.resize(32, 32, Image.INTERPOLATE_LANCZOS)
		var item := list.create_item(role_item)
		item.set_text(0, unit.title)
		item.set_icon(0, ImageTexture.create_from_image(img))
		item.set_metadata(0, unit)
```
