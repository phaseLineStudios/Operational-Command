# CampaignSave::complete_mission Function Reference

*Defined at:* `scripts/data/CampaignSave.gd` (lines 52–56)</br>
*Belongs to:* [CampaignSave](../../CampaignSave.md)

**Signature**

```gdscript
func complete_mission(mission_id: String) -> void
```

## Description

Mark a mission as completed.

## Source

```gdscript
func complete_mission(mission_id: String) -> void:
	if mission_id not in completed_missions:
		completed_missions.append(mission_id)
```
