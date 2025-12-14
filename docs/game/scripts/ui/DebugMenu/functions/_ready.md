# DebugMenu::_ready Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 43–77)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _ready()
```

## Source

```gdscript
func _ready():
	hide()
	metrics_visibility.item_selected.connect(_set_metrics_visibility)
	connect("close_requested", _close)
	scene_loader_button.pressed.connect(_on_load_pressed)
	_populate_scene_list()
	LogService.line.connect(_log_msg)
	set_process(true)

	event_log_filter_log.pressed.connect(_refresh_log)
	event_log_filter_info.pressed.connect(_refresh_log)
	event_log_filter_warning.pressed.connect(_refresh_log)
	event_log_filter_error.pressed.connect(_refresh_log)
	event_log_filter_trace.pressed.connect(_refresh_log)
	event_log_filter_debug.pressed.connect(_refresh_log)
	event_log_clear.pressed.connect(_clear_log)

	scene_options_refresh.pressed.connect(_refresh_scene_options)

	# Initialize save editor
	_save_editor = DebugMenuSaveEditor.new(save_editor_save_name, save_editor_content)
	save_editor_refresh.pressed.connect(func(): _save_editor.refresh(self))
	save_editor_tab.name = "Save Editor"

	# Initialize mission editor (if Mission tab UI exists in scene)
	if mission_status and mission_content and mission_refresh and mission_tab:
		_mission_editor = DebugMenuMission.new(mission_status, mission_content)
		mission_refresh.pressed.connect(func(): _mission_editor.refresh(self))
		mission_tab.name = "Mission"

	_refresh_scene_options()
	_save_editor.refresh(self)
	_update_mission_tab_visibility()
```
