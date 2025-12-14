# Persistence::create_new_campaign_save Function Reference

*Defined at:* `scripts/core/Persistence.gd` (lines 73–79)</br>
*Belongs to:* [Persistence](../../Persistence.md)

**Signature**

```gdscript
func create_new_campaign_save(campaign_id: StringName, save_name: String = "") -> String
```

## Description

Create a new save for `campaign_id`; return new ID.

## Source

```gdscript
func create_new_campaign_save(campaign_id: StringName, save_name: String = "") -> String:
	var save: CampaignSave = CampaignSave.create_new(campaign_id, save_name)
	save_to_file(save)
	_save_cache[save.save_id] = save
	return save.save_id
```
