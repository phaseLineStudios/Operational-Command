# OCMenuWindow::_ok_pressed Function Reference

*Defined at:* `scripts/ui/controls/OcMenuWindow.gd` (lines 85–89)</br>
*Belongs to:* [OCMenuWindow](../../OCMenuWindow.md)

**Signature**

```gdscript
func _ok_pressed() -> void
```

## Description

Emitts ok pressed event

## Source

```gdscript
func _ok_pressed() -> void:
	LogService.trace("OK Pressed", "OcMenuWindow.gd: 43")
	emit_signal("ok_pressed")
```
