# CampaignSave::is_mission_completed Function Reference

*Defined at:* `scripts/data/CampaignSave.gd` (lines 58–61)</br>
*Belongs to:* [CampaignSave](../../CampaignSave.md)

**Signature**

```gdscript
func is_mission_completed(mission_id: String) -> bool
```

## Description

Check if a mission is completed.

## Source

```gdscript
func is_mission_completed(mission_id: String) -> bool:
	return mission_id in completed_missions
```
