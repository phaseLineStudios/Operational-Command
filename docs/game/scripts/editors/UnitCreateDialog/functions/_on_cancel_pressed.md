# UnitCreateDialog::_on_cancel_pressed Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 266–271)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _on_cancel_pressed() -> void
```

## Description

Emit cancel signal.

## Source

```gdscript
func _on_cancel_pressed() -> void:
	hide()
	_reset_ui()
	emit_signal("canceled")
```
