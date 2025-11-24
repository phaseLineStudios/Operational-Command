# CampaignSelect::_delete_save Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 209–214)</br>
*Belongs to:* [CampaignSelect](../../CampaignSelect.md)

**Signature**

```gdscript
func _delete_save(save_id: String) -> void
```

## Description

Delete save by save id

## Source

```gdscript
func _delete_save(save_id: String) -> void:
	Game.delete_save(save_id)
	confirm_dialog.hide()
	_update_action_buttons()
```
