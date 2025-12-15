# PauseMenu::_on_resume_pressed Function Reference

*Defined at:* `scripts/ui/PauseMenu.gd` (lines 64–70)</br>
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
	_release_interactions()
	menu_container.visible = false
	visible = false
	emit_signal("resume_requested")
```
