extends Window

@onready var metrics_display: DebugMetricsDisplay = %MetricsDisplay
@onready var metrics_visibility: OptionButton = $Column/MetricsControl/MetricsVisibility
@onready var scene_loader_scene: OptionButton = $Column/SceneLoader/Scene
@onready var scene_loader_button: Button = $Column/SceneLoader/Load

func _ready():
	hide()
	metrics_visibility.item_selected.connect(_set_metrics_visibility)
	connect("close_requested", _close)
	scene_loader_button.pressed.connect(_on_load_pressed)
	_populate_scene_list()
	set_process(true)

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
	return (rel.substr(0, dot) if dot >= 0 else rel)

func _process(_dt: float) -> void:
	if Input.is_action_just_pressed("open_debug_menu"):
		if not visible:
			popup_centered()
			grab_focus()
		else:
			hide()

func _close():
	hide()
