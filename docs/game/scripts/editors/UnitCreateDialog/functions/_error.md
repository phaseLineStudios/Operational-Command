# UnitCreateDialog::_error Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 690–695)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _error(msg: String) -> String
```

- **msg**: Error message.
- **Return Value**: Same as `msg`.

## Description

Show error dialog.

## Source

```gdscript
func _error(msg: String) -> String:
	_error_dlg.dialog_text = msg
	_error_dlg.popup_centered()
	return msg
```
