# PauseMenu::_build_restart_dialog Function Reference

*Defined at:* `scripts/ui/PauseMenu.gd` (lines 53–62)</br>
*Belongs to:* [PauseMenu](../../PauseMenu.md)

**Signature**

```gdscript
func _build_restart_dialog()
```

## Source

```gdscript
func _build_restart_dialog():
	_restart_dialog = ConfirmationDialog.new()
	_restart_dialog.title = "Are you sure you want to restart?"
	_restart_dialog.dialog_text = "This will delete your scenario progress."
	_restart_dialog.get_ok_button().text = "Yes"
	_restart_dialog.get_cancel_button().text = "No"
	_restart_dialog.get_ok_button().pressed.connect(_on_restart_requested)
	add_child(_restart_dialog)
```
