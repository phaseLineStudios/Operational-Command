# CampaignSelect::_on_continue_last_pressed Function Reference

*Defined at:* `scripts/ui/CampaignSelect.gd` (lines 97–110)</br>
*Belongs to:* [CampaignSelect](../../CampaignSelect.md)

**Signature**

```gdscript
func _on_continue_last_pressed() -> void
```

## Description

resolves last save for the current campaign (if any).

## Source

```gdscript
func _on_continue_last_pressed() -> void:
	if not _selected_campaign:
		return

	var last_id := Persistence.get_last_save_id_for_campaign(_selected_campaign.id)
	if last_id != "":
		Game.select_campaign(_selected_campaign)
		Game.select_save(last_id)
		Game.goto_scene(MISSION_SELECT_SCENE)
	else:
		# TODO: show "no saves found" dialog
		push_warning("No previous save found for this campaign.")
```
