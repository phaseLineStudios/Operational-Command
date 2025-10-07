# ContentDB::get_scenarios Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 166–174)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func get_scenarios(ids: Array) -> Array[CampaignData]
```

## Description

Get multiple scenarios by IDs

## Source

```gdscript
func get_scenarios(ids: Array) -> Array[CampaignData]:
	var out: Array[CampaignData] = []
	for raw in ids:
		var s := get_campaign(String(raw))
		if s:
			out.append(s)
	return out
```
