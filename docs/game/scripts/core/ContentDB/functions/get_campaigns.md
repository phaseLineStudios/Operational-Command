# ContentDB::get_campaigns Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 120–128)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func get_campaigns(ids: Array) -> Array
```

## Description

Get multiple campaigns by IDs

## Source

```gdscript
func get_campaigns(ids: Array) -> Array:
	var out: Array[CampaignData] = []
	for raw in ids:
		var s := get_campaign(String(raw))
		if s:
			out.append(s)
	return out
```
