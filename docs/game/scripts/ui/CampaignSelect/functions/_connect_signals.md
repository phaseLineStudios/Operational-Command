# CampaignSelect::_connect_signals Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 42–59)</br>
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
	select_save.ok_pressed.connect(_select_save_load)
	select_save.cancel_pressed.connect(_select_save_close)
	select_save.close_pressed.connect(_select_save_close)
	select_save.content_selected.connect(func(idx: int): delete_save.disabled = idx == -1)
	delete_save.pressed.connect(_select_save_delete)
	new_save.ok_pressed.connect(_on_new_save_created)
	new_save.cancel_pressed.connect(_on_new_save_cancelled)
	new_save.close_pressed.connect(_on_new_save_cancelled)
	confirm_dialog.close_pressed.connect(func(): confirm_dialog.hide())
	confirm_dialog.cancel_pressed.connect(func(): confirm_dialog.hide())
```
