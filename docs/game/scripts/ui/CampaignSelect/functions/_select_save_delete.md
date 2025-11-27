# CampaignSelect::_select_save_delete Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 196–207)</br>
*Belongs to:* [CampaignSelect](../../CampaignSelect.md)

**Signature**

```gdscript
func _select_save_delete() -> void
```

## Description

Handle deletion of saves

## Source

```gdscript
func _select_save_delete() -> void:
	var selected := select_save.content_list.get_selected_items()
	if selected.size() > 0:
		var save_id: String = select_save.content_list.get_item_metadata(selected[0])
		var save_name: String = Persistence.load_save(save_id).save_name
		confirm_dialog.window_title = "Delete Save"
		confirm_dialog.description = "Are you sure you want to delete %s?" % save_name
		confirm_dialog.ok_pressed.connect(func(): _delete_save(save_id), CONNECT_ONE_SHOT)
		confirm_dialog.popup_centered()
	_select_save_close()
```
