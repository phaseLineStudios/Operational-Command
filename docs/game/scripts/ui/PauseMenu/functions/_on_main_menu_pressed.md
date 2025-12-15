# PauseMenu::_on_main_menu_pressed Function Reference

*Defined at:* `scripts/ui/PauseMenu.gd` (lines 102–106)</br>
*Belongs to:* [PauseMenu](../../PauseMenu.md)

**Signature**

```gdscript
func _on_main_menu_pressed() -> void
```

## Description

Called on main menu pressed.

## Source

```gdscript
func _on_main_menu_pressed() -> void:
	_exit_target = "res://scenes/main_menu.tscn"
	_exit_dialog.popup_centered()
```
