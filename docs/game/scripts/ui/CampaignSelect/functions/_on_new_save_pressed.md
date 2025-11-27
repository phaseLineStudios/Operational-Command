# CampaignSelect::_on_new_save_pressed Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 86–95)</br>
*Belongs to:* [CampaignSelect](../../CampaignSelect.md)

**Signature**

```gdscript
func _on_new_save_pressed() -> void
```

## Description

Create/select new save and go to Mission Select.

## Source

```gdscript
func _on_new_save_pressed() -> void:
	if not _selected_campaign:
		return

	var save_id := Persistence.create_new_campaign_save(_selected_campaign.id)
	Game.select_campaign(_selected_campaign)
	Game.select_save(save_id)
	Game.goto_scene(MISSION_SELECT_SCENE)
```
