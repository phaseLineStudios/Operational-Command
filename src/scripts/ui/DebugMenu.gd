class_name DebugMenu
extends Window

## Debug menu window that provides scene-wide debugging options
##
## This window contains multiple tabs:
## - Log: Shows filtered log messages from LogService
## - General: General debug options and scene loader
## - Scene Options: Auto-discovered debug options from nodes in the active scene
## - Save Editor: Edit currently selected save

var _log_lines: Array = []
var _scene_options_discovered: Array = []
var _is_scanning: bool = false
var _save_editor: DebugMenuSaveEditor

@onready var metrics_display: DebugMetricsDisplay = %MetricsDisplay
@onready var metrics_visibility: OptionButton = $TabContainer/General/Column/MetricsVisibility
@onready var scene_loader_scene: OptionButton = $TabContainer/General/Column/SceneLoader/Scene
@onready var scene_loader_button: Button = $TabContainer/General/Column/SceneLoader/Load
@onready var event_log_content: RichTextLabel = $TabContainer/Log/Column/Log/LogContent
@onready var event_log_clear: Button = $TabContainer/Log/Column/ActionsRow/ClearLog
@onready var event_log_filter_log: Button = %FilterLog
@onready var event_log_filter_info: Button = %FilterInfo
@onready var event_log_filter_warning: Button = %FilterWarning
@onready var event_log_filter_error: Button = %FilterError
@onready var event_log_filter_debug: Button = %FilterDebug
@onready var event_log_filter_trace: Button = %FilterTrace
@onready var scene_options_container: GridContainer = $TabContainer/Scene/ScrollContainer/Column
@onready var scene_options_refresh: Button = $TabContainer/Scene/RefreshRow/Refresh
@onready var scene_options_status: Label = $TabContainer/Scene/RefreshRow/Status
@onready var save_editor_save_name: Label = %SaveName
@onready var save_editor_refresh: Button = %Refresh
@onready var save_editor_content: GridContainer = %EditorContent
@onready var save_editor_tab: VBoxContainer = %SaveEditor


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

	_refresh_scene_options()
	_save_editor.refresh(self)


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

	var files := ResourceLoader.list_directory(path)
	for file in files:
		var is_dir := file[file.length() - 1] == "/"
		var extension := file.split(".")[-1]
		if not is_dir and extension in ["tscn", "scn"]:
			out.append(path.path_join(file))

		if is_dir:
			if (
				file.begins_with(".git")
				or file.begins_with(".godot")
				or file.begins_with(".import")
			):
				continue
			_recursive_collect_scenes(path.path_join(file), out)


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
			or (lvl == LogService.LogLevel.DEBUG and event_log_filter_debug.button_pressed)
			or (lvl == LogService.LogLevel.TRACE and event_log_filter_trace.button_pressed)
		):
			filtered_lines.append(txt)

	event_log_content.text = "\n".join(filtered_lines)


func _clear_log():
	_log_lines = []
	_refresh_log()


## Refresh scene options by scanning all nodes
func _refresh_scene_options() -> void:
	if _is_scanning:
		return

	_is_scanning = true
	scene_options_status.text = "Scanning..."
	scene_options_refresh.disabled = true

	_clear_scene_options_ui()

	_scan_scene_for_options.call_deferred()


## Clear all scene option UI elements
func _clear_scene_options_ui() -> void:
	for child in scene_options_container.get_children():
		child.queue_free()


## Async scan all nodes in the scene tree for debug options
func _scan_scene_for_options() -> void:
	_scene_options_discovered.clear()

	var root := get_tree().root
	var nodes_to_scan: Array[Node] = []
	_collect_nodes_recursive(root, nodes_to_scan)

	var total_nodes := nodes_to_scan.size()
	var scanned_count := 0
	var batch_size := 50

	while scanned_count < total_nodes:
		var batch_end := mini(scanned_count + batch_size, total_nodes)

		for i in range(scanned_count, batch_end):
			var node := nodes_to_scan[i]
			if node == null or not is_instance_valid(node):
				continue

			if _should_skip_node(node):
				continue

			var all_options: Array = []

			var export_options := _extract_debug_exports(node)
			all_options.append_array(export_options)

			if node.has_method("get_debug_options"):
				var manual_options = node.get_debug_options()
				if manual_options is Array:
					all_options.append_array(manual_options)

			if all_options.size() > 0:
				_scene_options_discovered.append({"node": node, "options": all_options})

		scanned_count = batch_end

		var progress := float(scanned_count) / float(total_nodes) * 100.0
		scene_options_status.text = "Scanning: %d%%" % int(progress)

		await get_tree().process_frame

	_build_scene_options_ui()

	scene_options_status.text = (
		"Found %d nodes with debug options" % _scene_options_discovered.size()
	)
	scene_options_refresh.disabled = false
	_is_scanning = false


## Check if we should skip scanning this node
func _should_skip_node(node: Node) -> bool:
	if node == self or node == get_parent():
		return true

	if node is Window:
		return true

	if node is CollisionShape3D:
		return true

	var node_name := node.name
	if node_name in ["Game", "ContentDB", "LogService", "Persistence", "STTService", "NARules"]:
		return true

	if node_name.begins_with("@"):
		return true

	return false


## Check if we should skip this property
func _should_skip_property(prop_name: String) -> bool:
	const SKIP_PROPERTIES := [
		"debug_draw",
		"physics_material_override",
		"input_pickable",
		"canvas_cull_mask",
	]

	if prop_name.begins_with("script_") or prop_name.begins_with("metadata_"):
		return true

	return prop_name in SKIP_PROPERTIES


## Extract debug-related @export variables from a node
func _extract_debug_exports(node: Node) -> Array:
	var options: Array = []
	var properties := node.get_property_list()
	var in_debug_category := false
	var in_debug_group := false

	for prop in properties:
		var prop_name: String = prop["name"]
		var prop_usage: int = prop["usage"]

		if prop_usage & PROPERTY_USAGE_CATEGORY:
			in_debug_category = prop_name.to_lower().contains("debug")
			continue

		if prop_usage & PROPERTY_USAGE_GROUP:
			in_debug_group = prop_name.to_lower().contains("debug")
			continue

		if not (prop_usage & PROPERTY_USAGE_EDITOR):
			continue

		if prop_usage & PROPERTY_USAGE_CLASS_IS_BITFIELD:
			continue

		var is_debug := false
		if prop_name.to_lower().contains("debug"):
			is_debug = true
		elif in_debug_category or in_debug_group:
			is_debug = true

		if not is_debug:
			continue

		if _should_skip_property(prop_name):
			continue

		var option := _property_to_option(node, prop)
		if option != null and not option.is_empty():
			options.append(option)

	return options


## Extract doc comment for a property from the script source
func _get_property_doc_comment(node: Node, prop_name: String) -> String:
	var script = node.get_script()
	if script == null:
		return ""

	var source_code: String = script.source_code
	if source_code == "":
		return ""

	var lines := source_code.split("\n")
	var doc_lines: Array[String] = []

	for i in range(lines.size()):
		var line := lines[i].strip_edges()

		var var_pattern := "var " + prop_name
		if line.contains(var_pattern):
			var pos := line.find(var_pattern)
			if pos >= 0:
				var after_var := pos + var_pattern.length()
				if after_var >= line.length() or line[after_var] in [":", "=", " ", "\t"]:
					var j := i - 1
					var found_any_comment := false
					var skip_empty_before_comment := true

					while j >= 0:
						var prev_line := lines[j].strip_edges()

						if prev_line.begins_with("##"):
							doc_lines.push_front(prev_line.substr(2).strip_edges())
							found_any_comment = true
							skip_empty_before_comment = false
							j -= 1

						elif prev_line.begins_with("@export"):
							if not found_any_comment:
								j -= 1
							else:
								break

						elif prev_line == "":
							if found_any_comment:
								break
							elif skip_empty_before_comment:
								skip_empty_before_comment = false
								j -= 1
							else:
								break

						else:
							break

					break

	return " ".join(doc_lines)


## Convert a property dictionary to a debug option dictionary
func _property_to_option(node: Node, prop: Dictionary) -> Dictionary:
	var prop_name: String = prop["name"]
	var prop_type: int = prop["type"]
	var prop_hint: int = prop.get("hint", 0)
	var prop_hint_string: String = prop.get("hint_string", "")

	var current_value = node.get(prop_name)
	var display_name := prop_name.replace("debug_", "").replace("_", " ").capitalize()
	var doc_comment := _get_property_doc_comment(node, prop_name)

	var option := {
		"name": display_name,
		"callback": func(value): node.set(prop_name, value),
		"tooltip": doc_comment
	}

	match prop_type:
		TYPE_BOOL:
			option["type"] = "bool"
			option["value"] = current_value

		TYPE_INT:
			option["type"] = "int"
			option["value"] = current_value
			if prop_hint == PROPERTY_HINT_RANGE and prop_hint_string != "":
				var parts := prop_hint_string.split(",")
				if parts.size() >= 2:
					option["min"] = float(parts[0])
					option["max"] = float(parts[1])
					if parts.size() >= 3:
						option["step"] = float(parts[2])
			elif prop_hint == PROPERTY_HINT_ENUM and prop_hint_string != "":
				option["type"] = "enum"
				option["options"] = prop_hint_string.split(",")

		TYPE_FLOAT:
			option["type"] = "float"
			option["value"] = current_value
			if prop_hint == PROPERTY_HINT_RANGE and prop_hint_string != "":
				var parts := prop_hint_string.split(",")
				if parts.size() >= 2:
					option["min"] = float(parts[0])
					option["max"] = float(parts[1])
					if parts.size() >= 3:
						option["step"] = float(parts[2])
					else:
						option["step"] = 0.01

		TYPE_STRING:
			option["type"] = "string"
			option["value"] = current_value
			if prop_hint == PROPERTY_HINT_ENUM and prop_hint_string != "":
				option["type"] = "enum"
				option["options"] = prop_hint_string.split(",")

		TYPE_VECTOR2, TYPE_VECTOR3, TYPE_COLOR:
			option["type"] = "string"
			option["value"] = str(current_value)
			option["callback"] = func(_value): pass

		_:
			return {}

	return option


## Recursively collect all nodes in the tree
func _collect_nodes_recursive(node: Node, out: Array[Node]) -> void:
	if node == null:
		return

	out.append(node)

	for child in node.get_children():
		_collect_nodes_recursive(child, out)


## Build UI for all discovered scene options
func _build_scene_options_ui() -> void:
	if _scene_options_discovered.is_empty():
		var label := Label.new()
		label.text = "No debug options found in scene."
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		scene_options_container.columns = 1
		scene_options_container.add_child(label)
		return

	scene_options_container.columns = 2

	for entry in _scene_options_discovered:
		var node: Node = entry["node"]
		var options: Array = entry["options"]

		# Add section separator (spans both columns by adding to both cells)
		var separator1 := HSeparator.new()
		separator1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		scene_options_container.add_child(separator1)
		var separator2 := HSeparator.new()
		separator2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		scene_options_container.add_child(separator2)

		# Add section header with node name (spans both columns by adding to both cells)
		var header := Label.new()
		header.text = node.name + " (%s)" % node.get_class()
		header.add_theme_font_size_override("font_size", 14)
		header.add_theme_color_override("font_color", Color.YELLOW)
		scene_options_container.add_child(header)
		# Add empty cell to complete the row
		var spacer := Control.new()
		scene_options_container.add_child(spacer)

		# Add each option
		for option in options:
			_add_debug_option(node, option)


## Add a single debug option to the UI
func _add_debug_option(node: Node, option: Dictionary) -> void:
	if not option.has("name") or not option.has("type"):
		return

	# Add label to first column
	var label := Label.new()
	label.text = option["name"]
	label.custom_minimum_size.x = 200
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# Apply tooltip if available
	var tooltip: String = option.get("tooltip", "")
	if tooltip != "":
		label.tooltip_text = tooltip

	scene_options_container.add_child(label)

	var type: String = option["type"]
	var callback: Callable = option.get("callback", Callable())

	# Add control to second column (will expand to fill)
	var control: Control = null

	match type:
		"bool":
			var checkbox := CheckBox.new()
			checkbox.button_pressed = option.get("value", false)
			if callback.is_valid():
				checkbox.toggled.connect(
					func(pressed: bool):
						if is_instance_valid(node):
							callback.call(pressed)
				)
			control = checkbox

		"int", "float":
			var spinbox := SpinBox.new()
			spinbox.value = option.get("value", 0.0)
			spinbox.min_value = option.get("min", -999999.0)
			spinbox.max_value = option.get("max", 999999.0)
			spinbox.step = option.get("step", 1.0 if type == "int" else 0.1)
			spinbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			if callback.is_valid():
				spinbox.value_changed.connect(
					func(value: float):
						if is_instance_valid(node):
							callback.call(value)
				)
			control = spinbox

		"string":
			var line_edit := LineEdit.new()
			line_edit.text = option.get("value", "")
			line_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			if callback.is_valid():
				line_edit.text_changed.connect(
					func(text: String):
						if is_instance_valid(node):
							callback.call(text)
				)
			control = line_edit

		"enum":
			var option_button := OptionButton.new()
			var options_list: Array = option.get("options", [])
			for opt in options_list:
				option_button.add_item(str(opt))
			var current_value = option.get("value", 0)
			if current_value is int:
				option_button.selected = current_value
			option_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			if callback.is_valid():
				option_button.item_selected.connect(
					func(index: int):
						if is_instance_valid(node):
							callback.call(index)
				)
			control = option_button

		"button":
			var button := Button.new()
			button.text = option.get("button_text", "Execute")
			button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			if callback.is_valid():
				button.pressed.connect(
					func():
						if is_instance_valid(node):
							callback.call()
				)
			control = button

	if control:
		# Apply tooltip to control as well
		if tooltip != "":
			control.tooltip_text = tooltip
		scene_options_container.add_child(control)


func _process(_dt: float) -> void:
	if Input.is_action_just_pressed("open_debug_menu"):
		if not visible:
			popup_centered_ratio(0.5)
			grab_focus()
		else:
			hide()


func _close():
	hide()
