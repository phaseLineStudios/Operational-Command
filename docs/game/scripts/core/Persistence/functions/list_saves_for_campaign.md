# Persistence::list_saves_for_campaign Function Reference

*Defined at:* `scripts/core/Persistence.gd` (lines 45–71)</br>
*Belongs to:* [Persistence](../../Persistence.md)

**Signature**

```gdscript
func list_saves_for_campaign(campaign_id: StringName) -> Array[CampaignSave]
```

## Description

Return array of CampaignSave objects for `campaign_id`.

## Source

```gdscript
func list_saves_for_campaign(campaign_id: StringName) -> Array[CampaignSave]:
	var saves: Array[CampaignSave] = []

	var dir := DirAccess.open(SAVE_DIR)
	if not dir:
		push_warning("Could not open save directory: %s" % SAVE_DIR)
		return saves

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json"):
			var save: CampaignSave = load_save_from_file(file_name.get_basename())
			if save and save.campaign_id == campaign_id:
				saves.append(save)
		file_name = dir.get_next()
	dir.list_dir_end()

	# Sort by last played timestamp (most recent first)
	saves.sort_custom(
		func(a: CampaignSave, b: CampaignSave) -> bool:
			return a.last_played_timestamp > b.last_played_timestamp
	)

	return saves
```
