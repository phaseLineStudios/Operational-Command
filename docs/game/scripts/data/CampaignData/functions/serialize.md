# CampaignData::serialize Function Reference

*Defined at:* `scripts/data/CampaignData.gd` (lines 25–53)</br>
*Belongs to:* [CampaignData](../../CampaignData.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

## Description

Serialize campaign data to JSON

## Source

```gdscript
func serialize() -> Dictionary:
	var scenario_dicts: Array = []
	for sc in scenarios:
		scenario_dicts.append(sc.serialize())

	return {
		"id": id,
		"title": title,
		"description": description,
		"preview_path":
		(
			preview.resource_path as Variant if preview and preview.resource_path != "" else null
			as Variant
		),
		"scenario_bg_path":
		(
			(
				scenario_bg.resource_path as Variant
				if scenario_bg and scenario_bg.resource_path != ""
				else null
			)
			as Variant
		),
		"scenarios": scenario_dicts,
		"order": order,
		"saves": saves.duplicate()
	}
```
