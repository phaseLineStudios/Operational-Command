# MissionSelect::_close_card Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 197–203)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

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
	_selected_mission = null
	_card_pin_button = null
```
