# SlotConfigDialog::_on_save Function Reference

*Defined at:* `scripts/editors/SlotConfigDialog.gd` (lines 46–73)</br>
*Belongs to:* [SlotConfigDialog](../../SlotConfigDialog.md)

**Signature**

```gdscript
func _on_save() -> void
```

## Description

Save slot config

## Source

```gdscript
func _on_save() -> void:
	if editor == null or slot_index < 0:
		return
	var live: UnitSlotData = editor.ctx.data.unit_slots[slot_index]

	var after := live.duplicate(true)
	after.key = key_input.text
	after.title = title_input.text
	after.callsign = callsign_input.text
	after.allowed_roles = _roles
	after.start_position = Vector2(pos_x.value, pos_y.value)

	if editor.history:
		var desc := "Edit Slot %s" % String(_before.title)
		editor.history.push_res_edit_by_id(
			editor.ctx.data, "unit_slots", "key", String(_before.key), _before, after, desc
		)
	else:
		live.key = after.key
		live.title = after.title
		live.callsign = after.callsign
		live.allowed_roles = after.allowed_roles

	visible = false
	editor.ctx.request_overlay_redraw()
	editor._rebuild_scene_tree()
```
