# CampaignSelect::_on_new_save_pressed Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 119–125)</br>
*Belongs to:* [CampaignSelect](../../CampaignSelect.md)

**Signature**

```gdscript
func _on_new_save_pressed() -> void
```

## Description

Create/select new save and go to Mission Select.

## Source

```gdscript
func _on_new_save_pressed() -> void:
	if not _selected_campaign:
		return

	new_save.popup_centered()
```
