# OCMenuWindow::_close_pressed Function Reference

*Defined at:* `scripts/ui/controls/OcMenuWindow.gd` (lines 97–101)</br>
*Belongs to:* [OCMenuWindow](../../OCMenuWindow.md)

**Signature**

```gdscript
func _close_pressed() -> void
```

## Description

Emitts ok pressed event

## Source

```gdscript
func _close_pressed() -> void:
	LogService.trace("Close Pressed", "OcMenuWindow.gd: 43")
	emit_signal("close_pressed")
```
