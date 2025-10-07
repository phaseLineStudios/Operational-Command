# TerrainEditor::_build_exit_dialog Function Reference

*Defined at:* `scripts/editors/TerrainEditor.gd` (lines 297–314)</br>
*Belongs to:* [TerrainEditor](../../TerrainEditor.md)

**Signature**

```gdscript
func _build_exit_dialog() -> void
```

## Description

Build exit dialog

## Source

```gdscript
func _build_exit_dialog() -> void:
	_exit_dialog = ConfirmationDialog.new()
	_exit_dialog.title = "Unsaved Changes"
	_exit_dialog.dialog_text = "Save changes before exiting?"
	_exit_dialog.get_ok_button().text = "Save"
	_exit_dialog.get_cancel_button().text = "Cancel"
	_exit_dialog.add_button("Don't Save", true, _EXIT_DISCARD_ACTION)
	add_child(_exit_dialog)

	_exit_dialog.confirmed.connect(_on_exit_save_confirmed)
	_exit_dialog.custom_action.connect(
		func(action: String):
			if action == _EXIT_DISCARD_ACTION:
				_perform_pending_exit()
	)
	_exit_dialog.canceled.connect(func(): _pending_exit_kind = "")
```
