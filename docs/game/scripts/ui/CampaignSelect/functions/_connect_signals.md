# CampaignSelect::_connect_signals Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 38–45)</br>
*Belongs to:* [CampaignSelect](../../CampaignSelect.md)

**Signature**

```gdscript
func _connect_signals() -> void
```

## Description

Connects UI signals to handlers.

## Source

```gdscript
func _connect_signals() -> void:
	list_campaigns.item_selected.connect(_on_campaign_selected)
	btn_new_save.pressed.connect(_on_new_save_pressed)
	btn_continue_last.pressed.connect(_on_continue_last_pressed)
	btn_select_save.pressed.connect(_on_select_save_pressed)
	btn_back.pressed.connect(_on_back_pressed)
```
