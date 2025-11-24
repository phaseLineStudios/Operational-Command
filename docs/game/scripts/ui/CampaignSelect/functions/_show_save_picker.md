# CampaignSelect::_show_save_picker Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 169–183)</br>
*Belongs to:* [CampaignSelect](../../CampaignSelect.md)

**Signature**

```gdscript
func _show_save_picker(saves: Array[CampaignSave]) -> void
```

## Description

Show save picker dialog.

## Source

```gdscript
func _show_save_picker(saves: Array[CampaignSave]) -> void:
	delete_save.disabled = true
	select_save.content_list.clear()
	select_save.popup_centered()

	for save in saves:
		var last_played := Time.get_datetime_string_from_unix_time(save.last_played_timestamp)

		var item_text := "%s (Last played: %s)" % [save.save_name, last_played.replace("T", " ")]
		select_save.content_list.add_item(item_text)
		select_save.content_list.set_item_metadata(
			select_save.content_list.item_count - 1, save.save_id
		)
```
