# CampaignSave::_extract_mission_number Function Reference

*Defined at:* `scripts/data/CampaignSave.gd` (lines 84–92)</br>
*Belongs to:* [CampaignSave](../../CampaignSave.md)

**Signature**

```gdscript
func _extract_mission_number(mission_id: String) -> int
```

## Description

Extract mission number from mission ID (e.g., "mission_03" -> 3).

## Source

```gdscript
func _extract_mission_number(mission_id: String) -> int:
	var regex := RegEx.new()
	regex.compile("\\d+")
	var result := regex.search(mission_id)
	if result:
		return result.get_string().to_int()
	return -1
```
