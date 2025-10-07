# PauseMenu::_build_exit_dialog Function Reference

*Defined at:* `scripts/ui/PauseMenu.gd` (lines 31–40)</br>
*Belongs to:* [PauseMenu](../../PauseMenu.md)

**Signature**

```gdscript
func _build_exit_dialog()
```

## Source

```gdscript
func _build_exit_dialog():
	_exit_dialog = ConfirmationDialog.new()
	_exit_dialog.title = "Are you sure you want to exit?"
	_exit_dialog.dialog_text = "This will delete your scenario progress."
	_exit_dialog.get_ok_button().text = "Yes"
	_exit_dialog.get_cancel_button().text = "No"
	_exit_dialog.get_ok_button().pressed.connect(func(): Game.goto_scene(_exit_target))
	add_child(_exit_dialog)
```
