# MainMenu::_ready Function Reference

*Defined at:* `scripts/ui/MainMenu.gd` (lines 40–73)</br>
*Belongs to:* [MainMenu](../../MainMenu.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	btn_campaign.pressed.connect(
		func():
			_collapse_if_needed()
			_go("campaign")
	)
	btn_scenarios.pressed.connect(
		func():
			_collapse_if_needed()
			_go("scenarios")
	)
	btn_multiplayer.pressed.connect(
		func():
			_collapse_if_needed()
			_go("multiplayer")
	)
	btn_settings.pressed.connect(
		func():
			_collapse_if_needed()
			_go("settings")
	)
	btn_quit.pressed.connect(
		func():
			_collapse_if_needed()
			_quit()
	)

	_wrap_editor_button()

	btn_editor.pressed.connect(_on_editor_pressed)

	_collapse_submenu()
```
