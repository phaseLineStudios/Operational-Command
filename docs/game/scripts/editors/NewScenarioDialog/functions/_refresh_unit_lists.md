# NewScenarioDialog::_refresh_unit_lists Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 310–344)</br>
*Belongs to:* [NewScenarioDialog](../../NewScenarioDialog.md)

**Signature**

```gdscript
func _refresh_unit_lists() -> void
```

## Description

Refresh both ItemLists from state.

## Source

```gdscript
func _refresh_unit_lists() -> void:
	if not is_instance_valid(unit_pool) or not is_instance_valid(unit_selected):
		return

	unit_pool.clear()
	unit_selected.clear()

	# Build a quick selected id set
	var sel_ids := {}
	for u in _selected_units:
		sel_ids[String(u.id)] = true

	# Pool = all - selected
	for u in _all_units:
		var uid := String(u.id)
		if sel_ids.has(uid):
			continue
		var idx := unit_pool.add_item(_unit_line(u))
		unit_pool.set_item_metadata(idx, {"id": uid})
		if u.icon:
			var img := u.icon.get_image()
			img.resize(24, 24, Image.INTERPOLATE_LANCZOS)
			unit_pool.set_item_icon(idx, ImageTexture.create_from_image(img))

	# Selected list
	for u in _selected_units:
		var uid := String(u.id)
		var idx := unit_selected.add_item(_unit_line(u))
		unit_selected.set_item_metadata(idx, {"id": uid})
		if u.icon:
			var img := u.icon.get_image()
			img.resize(24, 24, Image.INTERPOLATE_LANCZOS)
			unit_selected.set_item_icon(idx, ImageTexture.create_from_image(img))
```
