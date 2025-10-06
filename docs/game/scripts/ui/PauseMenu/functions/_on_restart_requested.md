# PauseMenu::_on_restart_requested Function Reference

*Defined at:* `scripts/ui/PauseMenu.gd` (lines 63–68)</br>
*Belongs to:* [PauseMenu](../PauseMenu.md)

**Signature**

```gdscript
func _on_restart_requested()
```

## Description

Called when restart is requested.

## Source

```gdscript
func _on_restart_requested():
	Game.resolution.finalize(true)
	get_tree().reload_current_scene()
	emit_signal("restart_requested")
```
