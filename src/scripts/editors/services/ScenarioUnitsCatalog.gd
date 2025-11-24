class_name ScenarioUnitsCatalog
extends RefCounted

var all_units: Array[UnitData]
var unit_categories: Array[UnitCategoryData]
var selected_category: UnitCategoryData
var slot_proto := UnitSlotData.new()


func setup(ctx: ScenarioEditorContext) -> void:
	slot_proto.title = "Playable Slot"
	all_units = ContentDB.list_units()
	unit_categories = ContentDB.list_unit_categories()
	_build_categories(ctx)
	_setup_tree(ctx)
	_setup_unit_create(ctx)
	_refresh(ctx)


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


func _set_faction(ctx: ScenarioEditorContext, aff) -> void:
	ctx.selected_unit_affiliation = aff
	ctx.unit_faction_friend.set_pressed_no_signal(aff == ScenarioUnit.Affiliation.FRIEND)
	ctx.unit_faction_enemy.set_pressed_no_signal(aff == ScenarioUnit.Affiliation.ENEMY)
	_refresh(ctx)


func _setup_tree(ctx: ScenarioEditorContext) -> void:
	var list := ctx.unit_list
	list.set_column_expand(0, true)
	list.set_column_custom_minimum_width(0, 200)
	if not list.item_selected.is_connected(func(): _on_tree_item(ctx)):
		list.item_selected.connect(func(): _on_tree_item(ctx))


func _on_tree_item(ctx: ScenarioEditorContext) -> void:
	var it := ctx.unit_list.get_selected()
	if it == null:
		return
	var payload: Variant = it.get_metadata(0)
	if payload is UnitData or payload is UnitSlotData:
		ctx.selection_changed.emit({"type": &"palette", "payload": payload})
	# Update button text when selection changes
	_update_button_text(ctx)


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

	# Update button text based on whether a unit is selected
	_update_button_text(ctx)


func _setup_unit_create(ctx: ScenarioEditorContext):
	if not ctx.unit_create_btn.pressed.is_connected(func(): _on_create_pressed(ctx)):
		ctx.unit_create_btn.pressed.connect(func(): _on_create_pressed(ctx))

	if not ctx.unit_create_dlg.unit_saved.is_connected(func(u, p): _on_unit_saved(ctx, u, p)):
		ctx.unit_create_dlg.unit_saved.connect(func(u, p): _on_unit_saved(ctx, u, p))

	if not ctx.unit_create_dlg.canceled.is_connected(func(): _on_dialog_closed(ctx)):
		ctx.unit_create_dlg.canceled.connect(func(): _on_dialog_closed(ctx))


func _on_create_pressed(ctx: ScenarioEditorContext) -> void:
	var sel = _get_selected_unit(ctx)
	if sel == null:
		ctx.unit_create_dlg.show_dialog(true, null)
	else:
		# Cancel the placement tool before opening the edit dialog
		_cancel_active_tool(ctx)
		ctx.unit_create_dlg.show_dialog(true, sel)


func _on_unit_saved(ctx: ScenarioEditorContext, unit: UnitData, _path: String) -> void:
	ContentDB.save_unit(unit)
	# Reload the unit list from ContentDB to pick up the new/edited unit
	all_units = ContentDB.list_units()
	_refresh(ctx)
	# Deselect after saving so user can select another unit
	_deselect_unit(ctx)


## Called when dialog is closed without saving
func _on_dialog_closed(ctx: ScenarioEditorContext) -> void:
	# Deselect so user can select another unit
	_deselect_unit(ctx)


## Get the UnitData from the current selection.
func _get_selected_unit(ctx: ScenarioEditorContext) -> UnitData:
	var it := ctx.unit_list.get_selected()
	if it == null:
		return
	var payload: Variant = it.get_metadata(0)
	if payload is UnitData:
		return payload

	return null


func _used_unit_ids(ctx: ScenarioEditorContext) -> Dictionary:
	var used := {}
	if ctx.data and ctx.data.units:
		for su: ScenarioUnit in ctx.data.units:
			if su and su.unit:
				used[String(su.unit.id)] = true
	return used


## Update the create/edit button text based on current selection
func _update_button_text(ctx: ScenarioEditorContext) -> void:
	var sel := _get_selected_unit(ctx)
	if sel != null:
		ctx.unit_create_btn.text = "* Edit Unit"
	else:
		ctx.unit_create_btn.text = "+ New Unit"


## Deselect the currently selected unit in the tree
func _deselect_unit(ctx: ScenarioEditorContext) -> void:
	var selected_item := ctx.unit_list.get_selected()
	if selected_item:
		selected_item.deselect(0)
	_update_button_text(ctx)


## Cancel the active tool if one is running
func _cancel_active_tool(ctx: ScenarioEditorContext) -> void:
	if ctx.current_tool:
		ctx.current_tool.deactivate()
		ctx.current_tool = null
