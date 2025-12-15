# CampaignSave::_is_mission_further Function Reference

*Defined at:* `scripts/data/CampaignSave.gd` (lines 71–82)</br>
*Belongs to:* [CampaignSave](../../CampaignSave.md)

**Signature**

```gdscript
func _is_mission_further(mission_a: String, mission_b: String) -> bool
```

## Description

Check if mission A is further than mission B in campaign order.
Simple heuristic: compare mission IDs lexicographically.

## Source

```gdscript
func _is_mission_further(mission_a: String, mission_b: String) -> bool:
	# Extract numeric suffix if present (e.g., "mission_01" -> 1)
	var num_a := _extract_mission_number(mission_a)
	var num_b := _extract_mission_number(mission_b)

	if num_a >= 0 and num_b >= 0:
		return num_a > num_b

	# Fallback to lexicographic comparison
	return mission_a > mission_b
```
