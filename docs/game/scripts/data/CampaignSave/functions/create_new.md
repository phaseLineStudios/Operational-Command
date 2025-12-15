# CampaignSave::create_new Function Reference

*Defined at:* `scripts/data/CampaignSave.gd` (lines 39–57)</br>
*Belongs to:* [CampaignSave](../../CampaignSave.md)

**Signature**

```gdscript
func create_new(p_campaign_id: String, p_save_name: String = "") -> Resource
```

## Description

Create a new campaign save with initial values.

## Source

```gdscript
static func create_new(p_campaign_id: String, p_save_name: String = "") -> Resource:
	var save = CampaignSave.new()
	save.set("campaign_id", p_campaign_id)
	save.set("save_id", "save_" + str(Time.get_unix_time_from_system()))
	save.set(
		"save_name",
		p_save_name if p_save_name != "" else "Save " + Time.get_datetime_string_from_system()
	)
	save.set("created_timestamp", Time.get_unix_time_from_system())
	save.set("last_played_timestamp", save.get("created_timestamp"))
	save.set("completed_missions", [])
	save.set("current_mission", "")
	save.set("furthest_mission", "")
	save.set("total_playtime_seconds", 0.0)
	save.set("unit_states", {})
	save.set("mission_start_states", {})
	return save
```
