# MissionSelect::_close_card Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 295–303)</br>
*Belongs to:* [MissionSelect](../MissionSelect.md)

**Signature**

```gdscript
func _close_card() -> void
```

## Description

Hide card and clear selection.

## Source

```gdscript
func _close_card() -> void:
	_card.visible = false
	_click_catcher.visible = false
	show_pin_labels = true
	_refresh_pin_labels()
	_selected_mission = null
	_card_pin_button = null
```
