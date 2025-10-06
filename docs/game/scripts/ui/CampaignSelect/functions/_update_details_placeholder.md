# CampaignSelect::_update_details_placeholder Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 68–75)</br>
*Belongs to:* [CampaignSelect](../CampaignSelect.md)

**Signature**

```gdscript
func _update_details_placeholder(campaign: CampaignData) -> void
```

## Description

Placeholder details update (to be replaced later).

## Source

```gdscript
func _update_details_placeholder(campaign: CampaignData) -> void:
	# TODO populate CampaignDetails UI later with real data
	# For now, just update the placeholder label if present
	var label := details_root.get_node_or_null("Panel/CampaignDetails/PlaceholderLabel") as Label
	if label:
		label.text = "CAMPAIGN DETAILS Placeholder\n\nSelected: %s" % [String(campaign.id)]
```
