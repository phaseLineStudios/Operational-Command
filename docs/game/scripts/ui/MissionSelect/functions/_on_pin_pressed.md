# MissionSelect::_on_pin_pressed Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 242–270)</br>
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
	if pin_click_sounds.size() > 0:
		AudioManager.play_random_ui_sound(pin_click_sounds, Vector2(1.0, 1.0), Vector2(0.9, 1.1))

	_selected_mission = mission
	_card_pin_button = pin_btn

	var is_locked: bool = _mission_locked.get(mission.id, false)

	_card_title.text = mission.title + (" [LOCKED]" if is_locked else "")
	_card_image.texture = mission.preview
	_card_desc.text = mission.description
	_card_diff.text = (
		"Difficulty: %s" % [ScenarioData.ScenarioDifficulty.keys()[mission.difficulty]]
	)

	_card_start.disabled = is_locked
	if is_locked:
		_card_start.text = "Locked - Complete previous missions"
	else:
		_card_start.text = "Start Mission"

	_card.visible = false
	_click_catcher.visible = false

	_card.visible = true
	_click_catcher.visible = true
```
