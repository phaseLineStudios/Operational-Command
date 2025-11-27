# CampaignSave::serialize Function Reference

*Defined at:* `scripts/data/CampaignSave.gd` (lines 81–94)</br>
*Belongs to:* [CampaignSave](../../CampaignSave.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

## Description

Serialize to JSON-compatible dictionary.

## Source

```gdscript
func serialize() -> Dictionary:
	return {
		"save_id": save_id,
		"save_name": save_name,
		"campaign_id": campaign_id,
		"created_timestamp": created_timestamp,
		"last_played_timestamp": last_played_timestamp,
		"completed_missions": completed_missions.duplicate(),
		"current_mission": current_mission,
		"total_playtime_seconds": total_playtime_seconds,
		"unit_states": unit_states.duplicate(true),
	}
```
