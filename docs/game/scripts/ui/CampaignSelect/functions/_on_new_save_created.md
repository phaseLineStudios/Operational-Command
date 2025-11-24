# CampaignSelect::_on_new_save_created Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 127–133)</br>
*Belongs to:* [CampaignSelect](../../CampaignSelect.md)

**Signature**

```gdscript
func _on_new_save_created() -> void
```

## Description

Create new save with entered name

## Source

```gdscript
func _on_new_save_created() -> void:
	var save_id := Persistence.create_new_campaign_save(_selected_campaign.id, new_save_name.text)
	Game.select_campaign(_selected_campaign)
	Game.select_save(save_id)
	Game.goto_scene(MISSION_SELECT_SCENE)
```
