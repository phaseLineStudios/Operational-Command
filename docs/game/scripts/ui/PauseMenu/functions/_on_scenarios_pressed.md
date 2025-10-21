# PauseMenu::_on_scenarios_pressed Function Reference

*Defined at:* `scripts/ui/PauseMenu.gd` (lines 82–86)</br>
*Belongs to:* [PauseMenu](../../PauseMenu.md)

**Signature**

```gdscript
func _on_scenarios_pressed() -> void
```

## Description

Called on scenario pressed.

## Source

```gdscript
func _on_scenarios_pressed() -> void:
	_exit_target = "res://scenes/mission_select.tscn"
	_exit_dialog.popup_centered()
```
