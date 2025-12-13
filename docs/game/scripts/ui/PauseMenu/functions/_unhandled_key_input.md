# PauseMenu::_unhandled_key_input Function Reference

*Defined at:* `scripts/ui/PauseMenu.gd` (lines 95–104)</br>
*Belongs to:* [PauseMenu](../../PauseMenu.md)

**Signature**

```gdscript
func _unhandled_key_input(event: InputEvent) -> void
```

## Source

```gdscript
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action("pause_menu") and event.is_pressed():
		visible = !visible
		if not visible:
			menu_container.visible = true
			_release_interactions()
		else:
			menu_container.visible = true
```
