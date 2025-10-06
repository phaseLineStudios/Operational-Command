# PauseMenu::_unhandled_key_input Function Reference

*Defined at:* `scripts/ui/PauseMenu.gd` (lines 93–95)</br>
*Belongs to:* [PauseMenu](../PauseMenu.md)

**Signature**

```gdscript
func _unhandled_key_input(event: InputEvent) -> void
```

## Source

```gdscript
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action("pause_menu") and event.is_pressed():
		visible = !visible
```
