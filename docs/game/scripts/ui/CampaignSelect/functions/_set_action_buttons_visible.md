# CampaignSelect::_set_action_buttons_visible Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 77–82)</br>
*Belongs to:* [CampaignSelect](../../CampaignSelect.md)

**Signature**

```gdscript
func _set_action_buttons_visible(state: bool) -> void
```

## Description

Show/hide the three action buttons.

## Source

```gdscript
func _set_action_buttons_visible(state: bool) -> void:
	btn_continue_last.visible = state
	btn_select_save.visible = state
	btn_new_save.visible = state
```
