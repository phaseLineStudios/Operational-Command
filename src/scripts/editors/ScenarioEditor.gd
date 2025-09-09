extends Control
class_name ScenarioEditor
## In-game scenario editor for custom scenarios.
##
## Lets creators place units, define objectives, establish spawn zones, and set
## environmental parameters. Saves to JSON compatible with ContentDB.gd.

## Initial Scenario Data
@export var data: ScenarioData

@onready var file_menu: MenuButton = %File
@onready var attribute_menu: MenuButton = %Attributes
@onready var title_label: Label = %ScenarioTitle
@onready var terrain_render: TerrainRender = %World
@onready var new_scenario_dialog: NewScenarioDialog = %NewScenarioDialog
@onready var weather_dialog: ScenarioWeatherDialog = %WeatherDialog
@onready var terrain_overlay: ScenarioEditorOverlay = %Overlay
@onready var tool_hint: HBoxContainer = %ToolHint
@onready var mouse_position_label: Label = %MousePosition

@onready var unit_category_opt: OptionButton = %UnitCategory
@onready var unit_search: LineEdit = %UnitSearch
@onready var unit_list: Tree = %Units
@onready var new_unit: Button = %NewUnit

const MAIN_MENU_SCENE := "res://scenes/main_menu.tscn"

var current_tool: ScenarioToolBase

var unit_categories: Array[UnitCategoryData]
var selected_category: UnitCategoryData
var all_units: Array[UnitData]

func _ready():
	file_menu.get_popup().connect("id_pressed", _on_filemenu_pressed)
	attribute_menu.get_popup().connect("id_pressed", _on_attributemenu_pressed)
	new_scenario_dialog.request_create.connect(_on_new_scenario)
	new_scenario_dialog.request_update.connect(_on_update_scenario)
	terrain_overlay.gui_input.connect(_on_overlay_gui_input)
	weather_dialog.editor = self
	terrain_overlay.editor = self
	
	all_units = ContentDB.list_units()
	unit_categories = ContentDB.list_unit_categories()
	unit_category_opt.item_selected.connect(_on_unit_category_select)
	unit_search.text_changed.connect(func(_d): _refresh_filter_units())
	_setup_units_tree()
	_rebuild_unit_categories()
	_refresh_filter_units()

func _on_filemenu_pressed(id: int):
	match id:
		0: new_scenario_dialog.show_dialog(true)
		4: Game.goto_scene(MAIN_MENU_SCENE)

func _on_attributemenu_pressed(id: int):
	match id:
		0:
			if data:
				new_scenario_dialog.show_dialog(true, data)
			else:
				new_scenario_dialog.show_dialog(true) 
		2: weather_dialog.show_dialog(true)

func _on_new_scenario(d: ScenarioData):
	data = d
	_on_data_changed()

func _on_update_scenario(_d: ScenarioData) -> void:
	_on_data_changed()

func _on_data_changed():
	title_label.text = data.title
	if data:
		title_label.text = data.title
		if data.terrain:
			terrain_render.data = data.terrain
	else:
		mouse_position_label.text = ""
	_request_overlay_redraw()


func set_tool(tool: ScenarioToolBase) -> void:
	if current_tool:
		current_tool.deactivate()
	current_tool = tool
	if current_tool:
		current_tool.activate(self)
		current_tool.request_redraw_overlay.connect(func(): _request_overlay_redraw())
		current_tool.hint_changed.connect(func(t): _set_tool_hint(t))
		current_tool.finished.connect(func(): clear_tool())
		current_tool.canceled.connect(func(): clear_tool())
		_request_overlay_redraw()
	else:
		_set_tool_hint("")

func clear_tool() -> void:
	set_tool(null)

func _request_overlay_redraw() -> void:
	terrain_overlay.request_redraw()

func _set_tool_hint(t: String) -> void:
	_queue_free_children(tool_hint)
	var label := Label.new()
	label.text = t
	tool_hint.add_child(label)

func _on_unit_category_select(idx: int) -> void:
	selected_category = unit_categories[idx]
	_refresh_filter_units()

func _rebuild_unit_categories() -> void:
	unit_category_opt.clear()
	for idx in range(unit_categories.size()):
		var cat := unit_categories[idx]
		unit_category_opt.add_item(cat.title, idx)
		var icon := cat.editor_icon
		var img := icon.get_image()
		img.resize(24, 24, Image.INTERPOLATE_LANCZOS)
		unit_category_opt.set_item_icon(idx, ImageTexture.create_from_image(img))
	selected_category = unit_categories[0]

func _setup_units_tree() -> void:
	unit_list.set_column_expand(0, true)
	unit_list.set_column_custom_minimum_width(0, 200)
	if not unit_list.item_selected.is_connected(_on_units_tree_item_activated):
		unit_list.item_selected.connect(_on_units_tree_item_activated)

func _refresh_filter_units() -> void:
	unit_list.clear()
	var root := unit_list.create_item()

	var query := unit_search.text.strip_edges().to_lower()
	var role_items := {}

	for unit in all_units:
		if unit.unit_category.id != selected_category.id:
			continue
		var text_ok := query.is_empty() \
			or unit.title.to_lower().find(query) >= 0 \
			or unit.id.to_lower().find(query) >= 0
		if not text_ok:
			continue

		var role_key := unit.role
		var role_item: TreeItem = role_items.get(role_key)
		if role_item == null:
			role_item = unit_list.create_item(root)
			role_item.set_text(0, unit.role)
			role_item.set_selectable(0, false)
			role_item.collapsed = false
			role_items[role_key] = role_item

		var item := unit_list.create_item(role_item)
		var icon := unit.icon
		if icon == null:
			icon = load("res://assets/textures/units/nato_unknown_platoon.png") as Texture2D
		var img := icon.get_image()
		img.resize(24, 24, Image.INTERPOLATE_LANCZOS)
	
		item.set_text(0, unit.title)
		item.set_icon(0, ImageTexture.create_from_image(img))
		item.set_metadata(0, unit)   

func _on_units_tree_item_activated() -> void:
	var it := unit_list.get_selected()
	if not it:
		return
	var payload: UnitData = it.get_metadata(0)
	if payload is UnitData:
		print("start tool")
		start_place_unit_tool(payload)

func start_place_unit_tool(u: UnitData) -> void:
	var tool := UnitPlaceTool.new()
	tool.unit = u
	set_tool(tool)

func _place_unit_from_tool(u: UnitData, pos_m: Vector2) -> void:
	if not data:
		push_warning("No active scenario")
		return
	var su := ScenarioUnit.new()
	su.unit = u
	su.position_m = pos_m
	if data.units == null:
		data.units = []
	data.units.append(su)
	_request_overlay_redraw()

func _unhandled_key_input(event):
	if current_tool and current_tool.handle_input(event):
		return

## Input handler for terrainview Viewport
func _on_overlay_gui_input(event):
	if event is InputEventMouseMotion:
		if data and data.terrain:
			var mp = terrain_render.map_to_terrain(event.position)
			var grid := terrain_render.pos_to_grid(mp)
			mouse_position_label.text = "(%d, %d | %s)" % [mp.x, mp.y, grid]

	if current_tool and current_tool.handle_input(event):
		return

## Helper function to delete all children of a parent node
func _queue_free_children(node: Control):
	for n in node.get_children():
		n.queue_free()
