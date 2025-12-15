# PauseMenu::_ready Function Reference

*Defined at:* `scripts/ui/PauseMenu.gd` (lines 20–42)</br>
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
	exit_editor_btn.pressed.connect(_on_exit_editor_pressed)

	_build_exit_dialog()
	_build_restart_dialog()

	# Configure buttons based on play mode
	if Game.play_mode == Game.PlayMode.SOLO_PLAY_TEST:
		scenarios_btn.visible = false
		main_menu_btn.visible = false
		exit_editor_btn.visible = true
	else:
		scenarios_btn.visible = true
		main_menu_btn.visible = true
		exit_editor_btn.visible = false
```
