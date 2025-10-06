# ContentDB::get_campaign Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 111–118)</br>
*Belongs to:* [ContentDB](../ContentDB.md)

**Signature**

```gdscript
func get_campaign(id: String) -> CampaignData
```

## Description

Campaigns helpers.
Get Campaign by ID

## Source

```gdscript
func get_campaign(id: String) -> CampaignData:
	var d := get_object("campaigns", id)
	if d.is_empty():
		push_warning("Campaign not found: %s" % id)
		return null
	return CampaignData.deserialize(d)
```
