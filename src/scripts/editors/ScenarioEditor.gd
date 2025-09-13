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
@onready var _slot_cfg: SlotConfigDialog = %SlotConfigDialog

@onready var unit_faction_friend: Button = %FactionRow/Friend
@onready var unit_faction_enemy: Button = %FactionRow/Enemy
@onready var unit_category_opt: OptionButton = %UnitCategory
@onready var unit_search: LineEdit = %UnitSearch
@onready var unit_list: Tree = %Units
@onready var new_unit: Button = %NewUnit

const MAIN_MENU_SCENE := "res://scenes/main_menu.tscn"

var current_tool: ScenarioToolBase

var _selected_unit_affiliation = ScenarioUnit.Affiliation.enemy
var unit_categories: Array[UnitCategoryData]
var selected_category: UnitCategoryData
var all_units: Array[UnitData]
var _slot_proto := UnitSlotData.new()

func _ready():
	file_menu.get_popup().connect("id_pressed", _on_filemenu_pressed)
	attribute_menu.get_popup().connect("id_pressed", _on_attributemenu_pressed)
	new_scenario_dialog.request_create.connect(_on_new_scenario)
	new_scenario_dialog.request_update.connect(_on_update_scenario)
	terrain_overlay.gui_input.connect(_on_overlay_gui_input)
	weather_dialog.editor = self
	terrain_overlay.editor = self
	if data.terrain:
		terrain_render.data = data.terrain
	
	_slot_proto.title = "Playable Slot"
	all_units = ContentDB.list_units()
	unit_categories = ContentDB.list_unit_categories()
	unit_category_opt.item_selected.connect(_on_unit_category_select)
	unit_search.text_changed.connect(func(_d): _refresh_filter_units())
	unit_faction_friend.pressed.connect(func (): _on_faction_changed(ScenarioUnit.Affiliation.friend))
	unit_faction_enemy.pressed.connect(func (): _on_faction_changed(ScenarioUnit.Affiliation.enemy))
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

func _on_faction_changed(affiliation: ScenarioUnit.Affiliation):
	if affiliation == ScenarioUnit.Affiliation.enemy:
		unit_faction_friend.set_pressed_no_signal(false)
		unit_faction_enemy.set_pressed_no_signal(true)
	elif affiliation == ScenarioUnit.Affiliation.friend:
		unit_faction_enemy.set_pressed_no_signal(false)
		unit_faction_friend.set_pressed_no_signal(true)
	else:
		return
	
	_selected_unit_affiliation = affiliation
	_refresh_filter_units()

func set_tool(tool: ScenarioToolBase) -> void:
	if current_tool:
		current_tool.deactivate()
	current_tool = tool
	if current_tool:
		current_tool.activate(self)
		current_tool.build_hint_ui(tool_hint)
		current_tool.request_redraw_overlay.connect(func(): _request_overlay_redraw())
		current_tool.finished.connect(func(): clear_tool())
		current_tool.canceled.connect(func(): clear_tool())
		_request_overlay_redraw()
	else:
		_queue_free_children(tool_hint)

func clear_tool() -> void:
	set_tool(null)

func _open_slot_config(index: int) -> void:
	if not data or not data.unit_slots: 
		return
	_slot_cfg.show_for(self, index)

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
	
	var show_slot := query.is_empty() \
		or "slot".findn(query) != -1 \
		or "playable".findn(query) != -1
	if show_slot:
		var pkey := "PLAYABLE"
		var pitem: TreeItem = role_items.get(pkey)
		if pitem == null:
			pitem = unit_list.create_item(root)
			pitem.set_text(0, "PLAYABLE")
			pitem.set_selectable(0, false)
			role_items[pkey] = pitem
		
		var icon := load("res://assets/textures/units/slot_icon.png") as Texture2D
		var img := icon.get_image()
		img.resize(24, 24, Image.INTERPOLATE_LANCZOS)
		
		var item := unit_list.create_item(pitem)
		item.set_text(0, _slot_proto.title)
		item.set_icon(0, ImageTexture.create_from_image(img))
		item.set_metadata(0, _slot_proto)

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
		var icon := unit.icon if _selected_unit_affiliation == ScenarioUnit.Affiliation.friend else unit.enemy_icon
		if icon == null:
			if _selected_unit_affiliation == ScenarioUnit.Affiliation.friend:
				icon = load("res://assets/textures/units/nato_unknown_platoon.png") as Texture2D
			else:
				icon = load("res://assets/textures/units/enemy_unknown_platoon.png") as Texture2D
		var img := icon.get_image()
		img.resize(24, 24, Image.INTERPOLATE_LANCZOS)
	
		item.set_text(0, unit.title)
		item.set_icon(0, ImageTexture.create_from_image(img))
		item.set_metadata(0, unit)

func _on_units_tree_item_activated() -> void:
	var it := unit_list.get_selected()
	if it == null: return
	var payload: Variant = it.get_metadata(0)
	if payload is UnitData or payload is UnitSlotData:
		start_place_unit_tool(payload)

func start_place_unit_tool(payload: Variant) -> void:
	var tool := UnitPlaceTool.new()
	tool.payload = payload
	set_tool(tool)

func _place_unit_from_tool(u: UnitData, pos_m: Vector2) -> void:
	if not data:
		push_warning("No active scenario")
		return
	var su := ScenarioUnit.new()
	su.unit = u
	su.position_m = pos_m
	su.affiliation = _selected_unit_affiliation
	print(_selected_unit_affiliation)
	if data.units == null:
		data.units = []
	data.units.append(su)
	_request_overlay_redraw()

## Commit a placed player slot into the scenario.
func _place_slot_from_tool(slot_def: UnitSlotData, pos_m: Vector2) -> void:
	if not data:
		push_warning("No active scenario"); return

	var inst := UnitSlotData.new()
	inst.key = _next_slot_key()
	inst.title = slot_def.title
	inst.allowed_roles = slot_def.allowed_roles.duplicate()
	inst.start_position = pos_m

	data.unit_slots.append(inst)

	_request_overlay_redraw()

## Generate a unique key like
func _next_slot_key() -> String:
	var n := 1
	if data and data.unit_slots:
		n = data.unit_slots.size() + 1
	return "SLOT_%d" % n

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
	
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			terrain_overlay.on_ctx_open(event)
			return
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			terrain_overlay.on_dbl_click(event)
			return

## Helper function to delete all children of a parent node
func _queue_free_children(node: Control):
	for n in node.get_children():
		n.queue_free()
