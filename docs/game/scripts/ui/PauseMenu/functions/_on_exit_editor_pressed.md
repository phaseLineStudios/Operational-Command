# PauseMenu::_on_exit_editor_pressed Function Reference

*Defined at:* `scripts/ui/PauseMenu.gd` (lines 124–125)</br>
*Belongs to:* [PauseMenu](../../PauseMenu.md)

**Signature**

```gdscript
func _on_exit_editor_pressed() -> void
```

## Description

Called on exit editor button pressed.

## Source

```gdscript
func _on_exit_editor_pressed() -> void:
	Game.end_playtest()
```
