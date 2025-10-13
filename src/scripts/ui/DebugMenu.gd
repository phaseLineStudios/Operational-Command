class_name DebugMenu
extends Window

var _log_lines: Array = []

@onready var metrics_display: DebugMetricsDisplay = %MetricsDisplay
@onready
var metrics_visibility: OptionButton = $TabContainer/General/Column/MetricsControl/MetricsVisibility
@onready var scene_loader_scene: OptionButton = $TabContainer/General/Column/SceneLoader/Scene
@onready var scene_loader_button: Button = $TabContainer/General/Column/SceneLoader/Load
@onready var event_log_content: RichTextLabel = $TabContainer/Log/Column/Log/LogContent
@onready var event_log_clear: Button = $TabContainer/Log/Column/ActionsRow/ClearLog
@onready var event_log_filter_log: Button = %FilterLog
@onready var event_log_filter_info: Button = %FilterInfo
@onready var event_log_filter_warning: Button = %FilterWarning
@onready var event_log_filter_error: Button = %FilterError
@onready var event_log_filter_trace: Button = %FilterTrace


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


## Set visibility for metrics display
func _set_metrics_visibility(visibility: int):
	metrics_display.style = visibility as DebugMetricsDisplay.Style


## Load scene
func _on_load_pressed() -> void:
	var idx := scene_loader_scene.get_selected()
	if idx < 0:
		return
	var path: String = scene_loader_scene.get_item_metadata(idx)
	if path == "" or path == null:
		return

	Game.goto_scene(path)
	hide()


## populate optionbutton with scenes
func _populate_scene_list() -> void:
	scene_loader_scene.clear()
	var scenes := _collect_scenes("res://")
	scenes.sort_custom(func(a, b): return String(a).nocasecmp_to(String(b)) < 0)

	for p in scenes:
		var scene_name := _pretty_scene_name(p)
		var i := scene_loader_scene.item_count
		scene_loader_scene.add_item(scene_name)
		scene_loader_scene.set_item_metadata(i, p)

	if scene_loader_scene.item_count > 0:
		scene_loader_scene.select(0)


## Collect all scenes
func _collect_scenes(root: String) -> Array:
	var out: Array = []
	_recursive_collect_scenes(root, out)
	return out


## recursivly collect all scenes in project
func _recursive_collect_scenes(path: String, out: Array) -> void:
	if path.ends_with("/.godot") or path.ends_with("/.import"):
		return

	for f in DirAccess.get_files_at(path):
		if f.ends_with(".tscn") or f.ends_with(".scn"):
			out.append(path.path_join(f))
	for d in DirAccess.get_directories_at(path):
		if d.begins_with(".git") or d == ".godot" or d == ".import":
			continue
		_recursive_collect_scenes(path.path_join(d), out)


## Prettify scene name
func _pretty_scene_name(p: String) -> String:
	var rel := p.replace("res://", "")
	var dot := rel.rfind(".")
	return rel.substr(0, dot) if dot >= 0 else rel


## Capture and store log message
func _log_msg(msg: String, lvl: LogService.LogLevel) -> void:
	_log_lines.append({"msg": msg, "lvl": lvl})
	_refresh_log()


## refresh log display
func _refresh_log():
	var filtered_lines := []
	for line in _log_lines:
		var lvl: LogService.LogLevel = line["lvl"]
		var txt: String = line["msg"]

		if (
			(lvl == LogService.LogLevel.LOG and event_log_filter_log.button_pressed)
			or (lvl == LogService.LogLevel.INFO and event_log_filter_info.button_pressed)
			or (lvl == LogService.LogLevel.WARNING and event_log_filter_warning.button_pressed)
			or (lvl == LogService.LogLevel.ERROR and event_log_filter_error.button_pressed)
			or (lvl == LogService.LogLevel.TRACE and event_log_filter_trace.button_pressed)
		):
			filtered_lines.append(txt)

	event_log_content.text = "\n".join(filtered_lines)


func _clear_log():
	_log_lines = []
	_refresh_log()


func _process(_dt: float) -> void:
	if Input.is_action_just_pressed("open_debug_menu"):
		if not visible:
			popup_centered()
			grab_focus()
		else:
			hide()


func _close():
	hide()
