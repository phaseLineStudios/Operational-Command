# MissionSelect::_on_pin_pressed Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 212–239)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

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
	_card_diff.text = (
		"Difficulty: %s" % [ScenarioData.ScenarioDifficulty.keys()[mission.difficulty]]
	)

	_prepare_card_for_float()

	_card.visible = false
	_click_catcher.visible = false

	show_pin_labels = false
	_refresh_pin_labels()

	_card.reset_size()
	var min_size := _card.get_combined_minimum_size()
	_card.size = min_size

	_position_card_near_pin(pin_btn)
	_card.visible = true
	_click_catcher.visible = true
```
