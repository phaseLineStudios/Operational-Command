# UnitCreateDialog::_on_save_pressed Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 284–293)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _on_save_pressed() -> void
```

## Description

Emit save signal.

## Source

```gdscript
func _on_save_pressed() -> void:
	var msg := _validate()
	if msg != "":
		return _error(msg)
	_collect_into_working()
	hide()
	_reset_ui()
	emit_signal("unit_saved", _working, "")
```
