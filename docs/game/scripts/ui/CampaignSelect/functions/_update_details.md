# CampaignSelect::_update_details Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 70–77)</br>
*Belongs to:* [CampaignSelect](../../CampaignSelect.md)

**Signature**

```gdscript
func _update_details(campaign: CampaignData) -> void
```

## Description

Placeholder details update (to be replaced later).

## Source

```gdscript
func _update_details(campaign: CampaignData) -> void:
	if campaign.preview != null:
		campaign_poster.texture = campaign.preview
	else:
		campaign_poster.texture = null
	campaign_desc.text = campaign.description
```
