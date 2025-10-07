# CampaignSelect::_on_campaign_selected Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 61–66)</br>
*Belongs to:* [CampaignSelect](../../CampaignSelect.md)

**Signature**

```gdscript
func _on_campaign_selected(index: int) -> void
```

## Description

Handle campaign selection; update details + show actions.

## Source

```gdscript
func _on_campaign_selected(index: int) -> void:
	_selected_campaign = _campaign_rows[index]
	_update_details_placeholder(_selected_campaign)
	_set_action_buttons_visible(true)
```
