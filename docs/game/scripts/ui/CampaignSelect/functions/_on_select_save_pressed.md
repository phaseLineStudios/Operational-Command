# CampaignSelect::_on_select_save_pressed Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 110–116)</br>
*Belongs to:* [CampaignSelect](../../CampaignSelect.md)

**Signature**

```gdscript
func _on_select_save_pressed() -> void
```

## Description

open a save picker filtered to the current campaign.

## Source

```gdscript
func _on_select_save_pressed() -> void:
	if not _selected_campaign:
		return
	# TODO Open a save picker dialog/scene filtered by campaign
	push_warning("Save selection UI not implemented yet.")
```
