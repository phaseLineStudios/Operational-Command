# Persistence::get_last_save_id_for_campaign Function Reference

*Defined at:* `scripts/core/Persistence.gd` (lines 26–43)</br>
*Belongs to:* [Persistence](../../Persistence.md)

**Signature**

```gdscript
func get_last_save_id_for_campaign(campaign_id: StringName) -> String
```

## Description

Return last save ID for `campaign_id`, or empty.

## Source

```gdscript
func get_last_save_id_for_campaign(campaign_id: StringName) -> String:
	var saves := list_saves_for_campaign(campaign_id)
	if saves.is_empty():
		return ""

	# Find the most recent save by last_played_timestamp
	var latest_save: CampaignSave = null
	var latest_timestamp := 0

	for save in saves:
		if save is CampaignSave:
			if save.last_played_timestamp > latest_timestamp:
				latest_timestamp = save.last_played_timestamp
				latest_save = save

	return latest_save.save_id if latest_save else ""
```
