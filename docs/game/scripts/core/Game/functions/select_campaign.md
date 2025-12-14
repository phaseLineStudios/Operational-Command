# Game::select_campaign Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 159–163)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func select_campaign(campaign: CampaignData) -> void
```

## Description

Set current campaign and emit `signal campaign_selected`.

## Source

```gdscript
func select_campaign(campaign: CampaignData) -> void:
	current_campaign = campaign
	emit_signal("campaign_selected", campaign.id)
```

## References

- [`signal campaign_selected`](../../Game.md#campaign_selected)
