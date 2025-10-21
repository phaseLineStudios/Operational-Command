# PauseMenu::_on_resume_pressed Function Reference

*Defined at:* `scripts/ui/PauseMenu.gd` (lines 52–56)</br>
*Belongs to:* [PauseMenu](../../PauseMenu.md)

**Signature**

```gdscript
func _on_resume_pressed() -> void
```

## Description

Called on resume button pressed.

## Source

```gdscript
func _on_resume_pressed() -> void:
	menu_container.visible = false
	emit_signal("resume_requested")
```
