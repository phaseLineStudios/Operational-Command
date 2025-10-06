# DebugMenu::_process Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 129–137)</br>
*Belongs to:* [DebugMenu](../DebugMenu.md)

**Signature**

```gdscript
func _process(_dt: float) -> void
```

## Source

```gdscript
func _process(_dt: float) -> void:
	if Input.is_action_just_pressed("open_debug_menu"):
		if not visible:
			popup_centered()
			grab_focus()
		else:
			hide()
```
