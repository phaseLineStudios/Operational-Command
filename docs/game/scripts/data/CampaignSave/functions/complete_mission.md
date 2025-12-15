# CampaignSave::complete_mission Function Reference

*Defined at:* `scripts/data/CampaignSave.gd` (lines 59–68)</br>
*Belongs to:* [CampaignSave](../../CampaignSave.md)

**Signature**

```gdscript
func complete_mission(mission_id: String) -> void
```

## Description

Mark a mission as completed and update furthest progress.

## Source

```gdscript
func complete_mission(mission_id: String) -> void:
	if mission_id not in completed_missions:
		completed_missions.append(mission_id)

	# Update furthest mission if this is new progress
	# This assumes missions have numeric suffixes or ordering
	if furthest_mission == "" or _is_mission_further(mission_id, furthest_mission):
		furthest_mission = mission_id
```
