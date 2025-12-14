# CampaignSelect::_populate_campaigns Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 61–75)</br>
*Belongs to:* [CampaignSelect](../../CampaignSelect.md)

**Signature**

```gdscript
func _populate_campaigns() -> void
```

## Description

Fill ItemList from ContentDB.

## Source

```gdscript
func _populate_campaigns() -> void:
	list_campaigns.clear()
	_campaign_rows.clear()

	var campaigns := ContentDB.list_campaigns()
	for c in campaigns:
		var title: String = c.title
		list_campaigns.add_item(title)
		_campaign_rows.append(c)

	if list_campaigns.item_count > 0:
		list_campaigns.select(0)
		_on_campaign_selected(0)
```
