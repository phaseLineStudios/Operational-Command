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
@onready var _unit_cfg: UnitConfigDialog = %UnitConfigDialog
@onready var _task_cfg: TaskConfigDialog = %TaskConfigDialog
@onready var scene_tree: Tree = %"Scene Tree"

@onready var unit_faction_friend: Button = %FactionRow/Friend
@onready var unit_faction_enemy: Button = %FactionRow/Enemy
@onready var unit_category_opt: OptionButton = %UnitCategory
@onready var unit_search: LineEdit = %UnitSearch
@onready var unit_list: Tree = %Units
@onready var new_unit: Button = %NewUnit

@onready var task_list: ItemList = %Tasks

const MAIN_MENU_SCENE := "res://scenes/main_menu.tscn"

const DEFAULT_FRIENDLY_CALLSIGNS: Array[String] = [
	"ALPHA","BRAVO","CHARLIE","DELTA","ECHO","FOXTROT","GOLF","HOTEL","INDIA",
	"JULIET","KILO","LIMA","MIKE","NOVEMBER","OSCAR","PAPA","QUEBEC","ROMEO",
	"SIERRA","TANGO","UNIFORM","VICTOR","WHISKEY","XRAY","YANKEE","ZULU"
]

const DEFAULT_ENEMY_CALLSIGNS: Array[String] = [
	"VICTOR", "BORIS", "IVAN", "SERGEI", "ANTON",
	"PAVEL", "DIMITRI", "MIKHAIL", "OSKAR", "YURI",
	"EGOR", "STEFAN", "NIKLAS", "ROLF", "GUNTER",
	"KLAUS", "DIETER", "HORST", "HELMUT", "ERICH",
	"MANFRED", "JURGEN", "ALARIC", "KONRAD", "ULRICH",
	"RUDOLF", "HENRIK", "VOLKMAR", "FALKO", "LEONID"
]

var current_tool: ScenarioToolBase
var selected_pick: Dictionary = {}
var _task_defs: Array[UnitBaseTask] = []
var _selected_task: UnitBaseTask
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
	
	_init_task_defs()
	_build_task_list()
	task_list.item_selected.connect(_on_task_item_selected)
	
	scene_tree.item_selected.connect(_on_scene_tree_item_selected)
	_setup_scene_tree()
	_rebuild_scene_tree()

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

func _open_unit_config(index: int) -> void:
	if not data or not data.units: return
	_unit_cfg.show_for(self, index)

func _open_task_config(task_index: int) -> void:
	if not data or data.tasks == null: return
	var inst: ScenarioTask = data.tasks[task_index]
	_task_cfg.show_for(self, inst)

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

## Create the available task definitions shown in the list.
func _init_task_defs() -> void:
	_task_defs.clear()
	_task_defs.append(UnitTask_Move.new())
	_task_defs.append(UnitTask_Defend.new())
	_task_defs.append(UnitTask_Wait.new())
	_task_defs.append(UnitTask_Patrol.new())
	_task_defs.append(UnitTask_SetBehaviour.new())
	_task_defs.append(UnitTask_SetCombatMode.new())

## Populate the Tasks ItemList with names
func _build_task_list() -> void:
	task_list.clear()
	for i in _task_defs.size():
		var t: UnitBaseTask = _task_defs[i]
		var icon_tex: Texture2D = t.icon
		var idx: int
		if icon_tex:
			var img := icon_tex.get_image()
			img.resize(24, 24, Image.INTERPOLATE_LANCZOS)
			idx = task_list.add_item(t.display_name, ImageTexture.create_from_image(img))
		else:
			idx = task_list.add_item(t.display_name)
		task_list.set_item_metadata(idx, t)

## Single-click: remember selection
func _on_task_item_selected(index: int) -> void:
	var meta: Variant = task_list.get_item_metadata(index)
	_selected_task = meta if meta is UnitBaseTask else null
	if meta is UnitBaseTask:
		start_place_task_tool(meta)

func _setup_scene_tree():
	scene_tree.set_column_expand(0, true)
	scene_tree.set_column_custom_minimum_width(0, 200)

func _rebuild_scene_tree():
	scene_tree.clear()
	var root := scene_tree.create_item()

	var slots := scene_tree.create_item(root)
	slots.set_text(0, "Slots")
	if data.unit_slots:
		for i in data.unit_slots.size():
			var slot: UnitSlotData = data.unit_slots[i]
			if slot == null: 
				continue
			var s_item := scene_tree.create_item(slots)
			s_item.set_text(0, slot.title)
			s_item.set_metadata(0, {"type": &"slot", "index": i})

	var units := scene_tree.create_item(root)
	units.set_text(0, "Units")
	if data.units:
		for ui in data.units.size():
			var su: ScenarioUnit = data.units[ui]
			if su == null: 
				continue
			var u_item := scene_tree.create_item(units)
			u_item.set_text(0, su.callsign)
			u_item.set_metadata(0, {"type": &"unit", "index": ui})
			
			if su.affiliation == ScenarioUnit.Affiliation.friend and su.unit.icon:
				var img := su.unit.icon.get_image()
				if not img.is_empty():
					img.resize(16, 16, Image.INTERPOLATE_LANCZOS)
					u_item.set_icon(0, ImageTexture.create_from_image(img))
			elif su.affiliation == ScenarioUnit.Affiliation.enemy and su.unit.enemy_icon:
				var img := su.unit.enemy_icon.get_image()
				if not img.is_empty():
					img.resize(16, 16, Image.INTERPOLATE_LANCZOS)
					u_item.set_icon(0, ImageTexture.create_from_image(img))

			var ordered := _collect_unit_task_chain(ui)
			for idx in ordered.size():
				var ti := ordered[idx]
				var inst: ScenarioTask = data.tasks[ti]
				if inst == null: continue
				var t_item := scene_tree.create_item(u_item)
				t_item.set_text(0, _make_task_title(inst, idx))
				t_item.set_metadata(0, {"type": &"task", "index": ti})

				if inst.task and inst.task.icon:
					var img := inst.task.icon.get_image()
					if not img.is_empty():
						img.resize(16, 16, Image.INTERPOLATE_LANCZOS)
						t_item.set_icon(0, ImageTexture.create_from_image(img))

	_select_in_scene_tree(selected_pick)

func _on_scene_tree_item_selected() -> void:
	var it := scene_tree.get_selected()
	if it == null: return
	var meta: Variant = it.get_metadata(0)
	if typeof(meta) == TYPE_DICTIONARY and meta.has("type") and meta.has("index"):
		_set_selection(meta, true)

func _on_units_tree_item_activated() -> void:
	var it := unit_list.get_selected()
	if it == null: return
	var payload: Variant = it.get_metadata(0)
	if payload is UnitData or payload is UnitSlotData:
		start_place_unit_tool(payload)

## Place and chain a task for a unit. Uses prev/next on TaskInstance
func _place_task_for_unit(unit_index: int, task: UnitBaseTask, pos_m: Vector2, after_task_index: int = -1) -> int:
	if not data or not task:
		return -1
	if data.tasks == null:
		data.tasks = []

	var inst := ScenarioTask.new()
	inst.id = _generate_task_instance_id(task.type_id)
	inst.task = task
	inst.unit_index = unit_index
	inst.position_m = pos_m
	inst.params = task.make_default_params()
	inst.prev_index = -1
	inst.next_index = -1

	if after_task_index >= 0 and after_task_index < data.tasks.size():
		var after: ScenarioTask = data.tasks[after_task_index]
		inst.prev_index = after_task_index
		inst.next_index = after.next_index
	else:
		var tail_idx := _find_tail_task_index(unit_index)
		inst.prev_index = tail_idx
		inst.next_index = -1

	var new_idx := data.tasks.size()
	data.tasks.append(inst)

	if inst.prev_index >= 0 and inst.prev_index < data.tasks.size():
		data.tasks[inst.prev_index].next_index = new_idx
	if inst.next_index >= 0 and inst.next_index < data.tasks.size():
		data.tasks[inst.next_index].prev_index = new_idx

	_request_overlay_redraw()
	_set_selection({"type": &"task", "index": new_idx})
	return new_idx

func start_place_task_tool(task: UnitBaseTask) -> void:
	var tool := TaskPlaceTool.new()
	tool.task = task
	set_tool(tool)

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
	su.callsign = _generate_callsign(_selected_unit_affiliation)
	su.id = _generate_unit_instance_id_for(u)
	if data.units == null:
		data.units = []
	data.units.append(su)
	_request_overlay_redraw()
	_rebuild_scene_tree()

## Commit a placed player slot into the scenario.
func _place_slot_from_tool(slot_def: UnitSlotData, pos_m: Vector2) -> void:
	if not data:
		push_warning("No active scenario"); return

	var inst := UnitSlotData.new()
	inst.key = _next_slot_key()
	inst.title = _generate_callsign(ScenarioUnit.Affiliation.friend)
	inst.allowed_roles = slot_def.allowed_roles.duplicate()
	inst.start_position = pos_m

	data.unit_slots.append(inst)

	_request_overlay_redraw()
	_rebuild_scene_tree()

## Generate a unique key like
func _next_slot_key() -> String:
	var n := 1
	if data and data.unit_slots:
		n = data.unit_slots.size() + 1
	return "SLOT_%d" % n

## Delete the entity described by pick
func _delete_pick(pick: Dictionary) -> void:
	var t := StringName(pick.get("type",""))
	var idx := int(pick.get("index",-1))
	match t:
		&"unit":
			_delete_unit(idx)
		&"slot":
			_delete_slot(idx)
		&"task":
			_delete_task(idx)
		_:
			return
	_clear_selection()
	_request_overlay_redraw()
	_rebuild_scene_tree()

## Delete unit at index and all its tasks; compact indices
func _delete_unit(unit_index: int) -> void:
	if not data or not data.units: return
	if unit_index < 0 or unit_index >= data.units.size(): return

	if data.tasks:
		var to_remove: Array[int] = []
		for i in data.tasks.size():
			var ti: ScenarioTask = data.tasks[i]
			if ti and ti.unit_index == unit_index:
				to_remove.append(i)
		to_remove.sort()
		for i in range(to_remove.size()-1, -1, -1):
			_delete_task(to_remove[i])

	data.units.remove_at(unit_index)

	if data.tasks:
		for ti in data.tasks:
			if ti and ti.unit_index > unit_index:
				ti.unit_index -= 1

## Delete slot at index
func _delete_slot(slot_index: int) -> void:
	if not data or not data.unit_slots: return
	if slot_index < 0 or slot_index >= data.unit_slots.size(): return
	data.unit_slots.remove_at(slot_index)

## Delete task at index. Repairs chain links and compacts indices
func _delete_task(task_index: int) -> void:
	if not data or not data.tasks: return
	if task_index < 0 or task_index >= data.tasks.size(): return
	var inst: ScenarioTask = data.tasks[task_index]
	if inst == null:
		data.tasks.remove_at(task_index)
		_reindex_task_links_after(task_index)
		return

	var prev_idx := inst.prev_index
	var next_idx := inst.next_index
	if prev_idx >= 0 and prev_idx < data.tasks.size():
		var prev := data.tasks[prev_idx]
		if prev: prev.next_index = next_idx
	if next_idx >= 0 and next_idx < data.tasks.size():
		var nxt := data.tasks[next_idx]
		if nxt: nxt.prev_index = prev_idx

	data.tasks.remove_at(task_index)

	_reindex_task_links_after(task_index)

## Returns the callsign pool for the given affiliation, with fallbacks.
func _get_callsign_pool(affiliation: ScenarioUnit.Affiliation) -> Array[String]:
	var pool: Array[String]
	if affiliation == ScenarioUnit.Affiliation.friend:
		if (data and data.friendly_callsigns and data.friendly_callsigns.size() > 0):
			pool = data.friendly_callsigns
		else:
			pool = DEFAULT_FRIENDLY_CALLSIGNS
	else:
		if (data and data.enemy_callsigns and data.enemy_callsigns.size() > 0):
			pool = data.enemy_callsigns
		else:
			pool = DEFAULT_ENEMY_CALLSIGNS
	# Normalize to strings
	var out: Array[String] = []
	for v in pool:
		out.append(str(v))
	return out

## Builds a set of used callsigns for an affiliation.
func _collect_used_callsigns(affiliation: ScenarioUnit.Affiliation) -> Dictionary:
	var used := {}
	if not data:
		return used

	if data.units:
		for su in data.units:
			if su and su.affiliation == affiliation:
				var cs := String(su.callsign).strip_edges()
				if not cs.is_empty():
					used[cs] = true

	if data.unit_slots:
		for s in data.unit_slots:
			if s and ScenarioUnit.Affiliation.friend == affiliation:
				var title := String(s.title).strip_edges()
				if not title.is_empty():
					used[title] = true

	return used

## Generate the next available callsign for an affiliation.
func _generate_callsign(affiliation: ScenarioUnit.Affiliation) -> String:
	var pool := _get_callsign_pool(affiliation)
	if pool.is_empty():
		return "UNIT"
	var used := _collect_used_callsigns(affiliation)
	var cls_wrap := 0
	var idx := 0
	while true:
		var base := pool[idx]
		var candidate := base if (cls_wrap == 0) else "%s-%d" % [base, cls_wrap]
		if not used.has(candidate):
			return candidate
		idx += 1
		if idx >= pool.size():
			idx = 0
			cls_wrap += 1
	return "UNIT"

## Next unique id for a unit entity
func _generate_unit_instance_id_for(u: UnitData) -> String:
	var base := String(u.id)
	if base.is_empty():
		base = "unit"

	var used := {}
	if data and data.units:
		var prefix := base + "_"
		for su in data.units:
			if su and su.unit and String(su.unit.id) == base and su.id is String:
				var sid: String = su.id
				if sid.begins_with(prefix):
					var suffix := sid.substr(prefix.length())
					if suffix.is_valid_int():
						used[int(suffix)] = true

	var n := 1
	while used.has(n):
		n += 1
	return "%s_%d" % [base, n]

func _generate_task_instance_id(type_id: StringName) -> String:
	var base := "task_%s" % String(type_id)
	if data.tasks == null: return "%s_1" % base
	var used := {}
	for t in data.tasks:
		if t and t.id is String and t.id.begins_with(base + "_"):
			var s := (t.id as String).substr(base.length() + 1)
			if s.is_valid_int(): used[int(s)] = true
	var n := 1
	while used.has(n): n += 1
	return "%s_%d" % [base, n]

## Find the current tail TaskInstance index for a unit
func _find_tail_task_index(unit_index: int) -> int:
	if data == null or data.tasks == null:
		return -1
	var tail := -1
	for i in data.tasks.size():
		var ti: ScenarioTask = data.tasks[i]
		if ti and ti.unit_index == unit_index and ti.next_index == -1:
			tail = i
	return tail

func _unhandled_key_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_DELETE:
		if not selected_pick.is_empty():
			_delete_pick(selected_pick)
			get_viewport().set_input_as_handled()
			return

	if current_tool and current_tool.handle_input(event):
		return

## Input handler for terrainview Viewport
func _on_overlay_gui_input(event):
	if event is InputEventMouseMotion:
		if data and data.terrain:
			var mp = terrain_render.map_to_terrain(event.position)
			var grid := terrain_render.pos_to_grid(mp)
			mouse_position_label.text = "(%d, %d | %s)" % [mp.x, mp.y, grid]
			terrain_overlay.on_mouse_move(event.position)

	if current_tool and current_tool.handle_input(event):
		return
	
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			terrain_overlay.on_ctx_open(event)
			return
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			terrain_overlay.on_dbl_click(event)
			return
		if event.button_index == MOUSE_BUTTON_LEFT:
			var pick := terrain_overlay.get_pick_at(event.position)
			if pick.is_empty():
				_clear_selection()
			else:
				_set_selection(pick)
			return

func _set_selection(pick: Dictionary, from_tree: bool = false) -> void:
	selected_pick = pick if pick != null else {}
	terrain_overlay.set_selected(selected_pick)
	_request_overlay_redraw()
	if not from_tree:
		_select_in_scene_tree(pick)

func _clear_selection(from_tree: bool = false) -> void:
	selected_pick = {}
	terrain_overlay.clear_selected()
	_request_overlay_redraw()
	if not from_tree:
		scene_tree.deselect_all()

func _select_in_scene_tree(pick: Dictionary) -> void:
	if pick.is_empty():
		scene_tree.deselect_all(); return
	var root := scene_tree.get_root()
	if root == null: return
	_select_item_recursive(root, pick)

func _select_item_recursive(item: TreeItem, pick: Dictionary) -> bool:
	var meta: Variant = item.get_metadata(0)
	if typeof(meta) == TYPE_DICTIONARY \
	and meta.get("type","") == pick.get("type","") \
	and int(meta.get("index",-1)) == int(pick.get("index",-1)):
		scene_tree.set_selected(item, 0)
		return true
	var child := item.get_first_child()
	while child:
		if _select_item_recursive(child, pick):
			return true
		child = child.get_next()
	return false

func _collect_unit_task_chain(unit_index: int) -> Array[int]:
	var out: Array[int] = []
	if data == null or data.tasks == null: return out

	var visited := {}
	var heads: Array[int] = []
	for i in data.tasks.size():
		var t: ScenarioTask = data.tasks[i]
		if t and t.unit_index == unit_index and t.prev_index == -1:
			heads.append(i)

	for h in heads:
		var cur := h
		while cur >= 0 and cur < data.tasks.size() and not visited.has(cur):
			visited[cur] = true
			out.append(cur)
			var nxt := data.tasks[cur].next_index
			if nxt == cur: break # safety
			cur = nxt

	for i in data.tasks.size():
		var t2: ScenarioTask = data.tasks[i]
		if t2 and t2.unit_index == unit_index and not visited.has(i):
			out.append(i)

	return out

## Label shown in tree, e.g. "1. Move" or "3. Defend
func _make_task_title(inst: ScenarioTask, index_in_chain: int) -> String:
	var task_name := inst.task.display_name if (inst.task and inst.task.display_name != "") else "Task"
	return "%d: %s" % [index_in_chain + 1, task_name]

func _reindex_task_links_after(removed: int) -> void:
	for t in data.tasks:
		if t == null: continue
		if t.prev_index > removed: t.prev_index -= 1
		if t.next_index > removed: t.next_index -= 1

## Helper function to delete all children of a parent node
func _queue_free_children(node: Control):
	for n in node.get_children():
		n.queue_free()
