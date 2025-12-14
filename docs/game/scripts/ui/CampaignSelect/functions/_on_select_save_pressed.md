# CampaignSelect::_on_select_save_pressed Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 156–167)</br>
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

	var saves := Persistence.list_saves_for_campaign(_selected_campaign.id)
	if saves.is_empty():
		push_warning("No saves found for this campaign.")
		return

	_show_save_picker(saves)
```
