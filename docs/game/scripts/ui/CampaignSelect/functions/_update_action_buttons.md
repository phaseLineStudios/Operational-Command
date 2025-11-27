# CampaignSelect::_update_action_buttons Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 93–117)</br>
*Belongs to:* [CampaignSelect](../../CampaignSelect.md)

**Signature**

```gdscript
func _update_action_buttons() -> void
```

## Description

Update action button visibility and states based on existing saves.

## Source

```gdscript
func _update_action_buttons() -> void:
	if not _selected_campaign:
		btn_continue_last.visible = false
		btn_select_save.visible = false
		btn_new_save.visible = false
		return

	var saves := Persistence.list_saves_for_campaign(_selected_campaign.id)
	var has_saves := not saves.is_empty()

	btn_continue_last.visible = true
	btn_select_save.visible = true
	btn_new_save.visible = true

	btn_continue_last.disabled = not has_saves
	btn_select_save.disabled = not has_saves

	if has_saves:
		btn_continue_last.text = "Continue Last Save"
		btn_select_save.text = "Load Save (%d)" % saves.size()
	else:
		btn_continue_last.text = "Continue (No Saves)"
		btn_select_save.text = "Load Save (No Saves)"
```
