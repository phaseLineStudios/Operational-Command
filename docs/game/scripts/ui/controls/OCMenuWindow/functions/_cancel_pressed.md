# OCMenuWindow::_cancel_pressed Function Reference

*Defined at:* `scripts/ui/controls/OcMenuWindow.gd` (lines 91–95)</br>
*Belongs to:* [OCMenuWindow](../../OCMenuWindow.md)

**Signature**

```gdscript
func _cancel_pressed() -> void
```

## Description

Emitts ok pressed event

## Source

```gdscript
func _cancel_pressed() -> void:
	LogService.trace("Cancel Pressed", "OcMenuWindow.gd: 43")
	emit_signal("cancel_pressed")
```
