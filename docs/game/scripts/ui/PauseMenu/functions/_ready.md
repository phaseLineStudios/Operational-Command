# PauseMenu::_ready Function Reference

*Defined at:* `scripts/ui/PauseMenu.gd` (lines 19–30)</br>
*Belongs to:* [PauseMenu](../../PauseMenu.md)

**Signature**

```gdscript
func _ready()
```

## Source

```gdscript
func _ready():
	resume_btn.pressed.connect(_on_resume_pressed)
	restart_btn.pressed.connect(_on_restart_pressed)
	settings_btn.pressed.connect(_on_setting_show)
	settings.back_requested.connect(_on_setting_hide)
	scenarios_btn.pressed.connect(_on_scenarios_pressed)
	main_menu_btn.pressed.connect(_on_main_menu_pressed)

	_build_exit_dialog()
	_build_restart_dialog()
```
