# DebugMenu::_ready Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 20–36)</br>
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
	event_log_clear.pressed.connect(_clear_log)
```
