# CampaignSelect::_on_new_save_cancelled Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 135–139)</br>
*Belongs to:* [CampaignSelect](../../CampaignSelect.md)

**Signature**

```gdscript
func _on_new_save_cancelled() -> void
```

## Description

Called when new save is cancelled

## Source

```gdscript
func _on_new_save_cancelled() -> void:
	new_save.hide()
	new_save_name.text = "My Savegame"
```
