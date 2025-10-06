# MissionSelect::_on_pin_pressed Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 212–231)</br>
*Belongs to:* [MissionSelect](../MissionSelect.md)

**Signature**

```gdscript
func _on_pin_pressed(mission: ScenarioData, pin_btn: BaseButton) -> void
```

## Description

Open the mission card; create/remove image node depending on presence.

## Source

```gdscript
func _on_pin_pressed(mission: ScenarioData, pin_btn: BaseButton) -> void:
	_selected_mission = mission
	_card_pin_button = pin_btn
	_card_title.text = mission.title

	_card_image.texture = mission.preview

	_card_desc.text = mission.description
	_card_diff.text = "Difficulty: %s" % [mission.difficulty]

	# BUG Unhiding card removes theme
	_card.visible = true
	_click_catcher.visible = true
	_card.reset_size()
	show_pin_labels = false
	_refresh_pin_labels()

	call_deferred("_position_card_near_pin", pin_btn)
```
