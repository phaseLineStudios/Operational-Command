# CampaignSelect::_select_save_load Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 185–194)</br>
*Belongs to:* [CampaignSelect](../../CampaignSelect.md)

**Signature**

```gdscript
func _select_save_load() -> void
```

## Description

Load selected save

## Source

```gdscript
func _select_save_load() -> void:
	var selected := select_save.content_list.get_selected_items()
	if selected.size() > 0:
		var save_id: String = select_save.content_list.get_item_metadata(selected[0])
		Game.select_campaign(_selected_campaign)
		Game.select_save(save_id)
		Game.goto_scene(MISSION_SELECT_SCENE)
	_select_save_close()
```
