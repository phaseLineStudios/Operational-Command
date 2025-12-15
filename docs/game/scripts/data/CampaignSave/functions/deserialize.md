# CampaignSave::deserialize Function Reference

*Defined at:* `scripts/data/CampaignSave.gd` (lines 134–164)</br>
*Belongs to:* [CampaignSave](../../CampaignSave.md)

**Signature**

```gdscript
func deserialize(data: Variant) -> Resource
```

## Description

Deserialize from JSON dictionary.

## Source

```gdscript
static func deserialize(data: Variant) -> Resource:
	if typeof(data) != TYPE_DICTIONARY:
		return null

	var save: Resource = load("res://scripts/data/CampaignSave.gd").new()
	save.save_id = data.get("save_id", "")
	save.save_name = data.get("save_name", "")
	save.campaign_id = data.get("campaign_id", "")
	save.created_timestamp = int(data.get("created_timestamp", 0))
	save.last_played_timestamp = int(data.get("last_played_timestamp", 0))
	save.current_mission = data.get("current_mission", "")
	save.furthest_mission = data.get("furthest_mission", "")
	save.total_playtime_seconds = float(data.get("total_playtime_seconds", 0.0))

	var missions = data.get("completed_missions", [])
	if typeof(missions) == TYPE_ARRAY:
		var tmp: Array[String] = []
		for m in missions:
			if typeof(m) == TYPE_STRING:
				tmp.append(m)
		save.completed_missions = tmp

	var states = data.get("unit_states", {})
	if typeof(states) == TYPE_DICTIONARY:
		save.unit_states = states.duplicate(true)

	var mission_states = data.get("mission_start_states", {})
	if typeof(mission_states) == TYPE_DICTIONARY:
		save.mission_start_states = mission_states.duplicate(true)

	return save
```
