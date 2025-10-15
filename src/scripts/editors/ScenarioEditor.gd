class_name ScenarioEditor
extends Control

## Path to return to main menu scene
const MAIN_MENU_SCENE := "res://scenes/main_menu.tscn"

## Default NATO-style callsigns used for friendly units when none provided
const DEFAULT_FRIENDLY_CALLSIGNS: Array[String] = [
	"ALPHA",
	"BRAVO",
	"CHARLIE",
	"DELTA",
	"ECHO",
	"FOXTROT",
	"GOLF",
	"HOTEL",
	"INDIA",
	"JULIET",
	"KILO",
	"LIMA",
	"MIKE",
	"NOVEMBER",
	"OSCAR",
	"PAPA",
	"QUEBEC",
	"ROMEO",
	"SIERRA",
	"TANGO",
	"UNIFORM",
	"VICTOR",
	"WHISKEY",
	"XRAY",
	"YANKEE",
	"ZULU"
]

## Default adversary callsigns used for enemy units when none provided
const DEFAULT_ENEMY_CALLSIGNS: Array[String] = [
	"VICTOR",
	"BORIS",
	"IVAN",
	"SERGEI",
	"ANTON",
	"PAVEL",
	"DIMITRI",
	"MIKHAIL",
	"OSKAR",
	"YURI",
	"EGOR",
	"STEFAN",
	"NIKLAS",
	"ROLF",
	"GUNTER",
	"KLAUS",
	"DIETER",
	"HORST",
	"HELMUT",
	"ERICH",
	"MANFRED",
	"JURGEN",
	"ALARIC",
	"KONRAD",
	"ULRICH",
	"RUDOLF",
	"HENRIK",
	"VOLKMAR",
	"FALKO",
	"LEONID"
]

## Active scenario data resource bound to the editor UI
@export var data: ScenarioData
## Global undo/redo history stack for scenario edits
@export var history: ScenarioHistory

var ctx := ScenarioEditorContext.new()
var persistence := ScenarioPersistenceService.new()
var units := ScenarioUnitsCatalog.new()
var tasks := ScenarioTasksService.new()
var triggers := ScenarioTriggersService.new()
var tree_service := ScenarioSceneTreeService.new()
var selection := ScenarioSelectionService.new()
var draglink := ScenarioDragLinkService.new()

var _open_dlg: FileDialog
var _save_dlg: FileDialog
var _current_path := ""
var _dirty := false

@onready var file_menu: MenuButton = %File
@onready var attribute_menu: MenuButton = %Attributes
@onready var title_label: Label = %ScenarioTitle
@onready var terrain_render: TerrainRender = %World
@onready var new_scenario_dialog: NewScenarioDialog = %NewScenarioDialog
@onready var weather_dialog: ScenarioWeatherDialog = %WeatherDialog
@onready var brief_dialog: BriefingDialog = %BriefingDialog
@onready var terrain_overlay: ScenarioEditorOverlay = %Overlay
@onready var tool_hint: HBoxContainer = %ToolHint
@onready var mouse_position_label: Label = %MousePosition
@onready var scene_tree: Tree = %SceneTree
@onready var history_list: VBoxContainer = %History

@onready var unit_faction_friend: Button = %FactionRow/Friend
@onready var unit_faction_enemy: Button = %FactionRow/Enemy
@onready var unit_category_opt: OptionButton = %UnitCategory
@onready var unit_search: LineEdit = %UnitSearch
@onready var unit_list: Tree = %Units

@onready var task_list: ItemList = %Tasks
@onready var trigger_list: ItemList = %Triggers

@onready var _slot_cfg: SlotConfigDialog = %SlotConfigDialog
@onready var _unit_cfg: UnitConfigDialog = %UnitConfigDialog
@onready var _task_cfg: TaskConfigDialog = %TaskConfigDialog
@onready var _trigger_cfg: TriggerConfigDialog = %TriggerConfigDialog

@onready var _tab_container1: TabContainer = %TabContainer1


## Initialize context, services, signals, UI, and dialogs
func _ready():
	ctx.data = data
	if history == null:
		history = ScenarioHistory.new()
		add_child(history)
	ctx.history = history

	ctx.terrain_render = terrain_render
	ctx.terrain_overlay = terrain_overlay
	ctx.scene_tree = scene_tree
	ctx.tool_hint = tool_hint
	ctx.mouse_position_label = mouse_position_label

	ctx.unit_list = unit_list
	ctx.unit_category_opt = unit_category_opt
	ctx.unit_search = unit_search
	ctx.unit_faction_friend = unit_faction_friend
	ctx.unit_faction_enemy = unit_faction_enemy

	ctx.task_list = task_list
	ctx.trigger_list = trigger_list

	ctx.overlay_redraw_requested.connect(func(): terrain_overlay.request_redraw())
	ctx.scene_tree_rebuild_requested.connect(func(): _rebuild_scene_tree())
	ctx.toast_requested.connect(func(msg): _show_info(msg))
	ctx.selection_changed.connect(_on_ctx_selection_changed)

	file_menu.get_popup().connect("id_pressed", _on_filemenu_pressed)
	attribute_menu.get_popup().connect("id_pressed", _on_attributemenu_pressed)

	new_scenario_dialog.request_create.connect(_on_new_scenario)
	new_scenario_dialog.request_update.connect(_on_update_scenario)
	
	brief_dialog.editor = self
	brief_dialog.request_update.connect(_on_briefing_update)

	terrain_overlay.gui_input.connect(_on_overlay_gui_input)
	weather_dialog.editor = self
	terrain_overlay.editor = self

	if ctx.data and ctx.data.terrain:
		terrain_render.data = ctx.data.terrain

	units.setup(ctx)
	tasks.setup(ctx)
	triggers.build_palette(ctx)
	tree_service.setup(tasks)
	_setup_scene_tree_signals()

	history.history_changed.connect(_on_history_changed)
	_on_history_changed([], [])
	_init_file_dialogs()
	_update_title()

	# fix tab container name
	_tab_container1.set_tab_title(0, "Scene Tree")


## Create and configure FileDialog instances
func _init_file_dialogs() -> void:
	_open_dlg = FileDialog.new()
	_open_dlg.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	_open_dlg.access = FileDialog.ACCESS_FILESYSTEM
	_open_dlg.filters = ScenarioPersistenceService.JSON_FILTER
	_open_dlg.title = "Open Scenario"
	_open_dlg.file_selected.connect(_on_open_file_selected)
	add_child(_open_dlg)

	_save_dlg = FileDialog.new()
	_save_dlg.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	_save_dlg.access = FileDialog.ACCESS_FILESYSTEM
	_save_dlg.filters = ScenarioPersistenceService.JSON_FILTER
	_save_dlg.title = "Save Scenario As"
	_save_dlg.file_selected.connect(_on_save_file_selected)
	add_child(_save_dlg)


## Connect scene tree selection to selection service
func _setup_scene_tree_signals() -> void:
	scene_tree.item_selected.connect(
		func():
			var it := scene_tree.get_selected()
			if it == null:
				return
			var meta: Variant = it.get_metadata(0)
			if typeof(meta) == TYPE_DICTIONARY and meta.has("type") and meta.has("index"):
				selection.set_selection(ctx, meta, true)
	)


## Rebuild the left scene tree and restore selection
func _rebuild_scene_tree() -> void:
	tree_service.rebuild(ctx)
	if not ctx.selected_pick.is_empty():
		selection.set_selection(ctx, ctx.selected_pick, true)


## Handle palette selections (units, tasks, triggers)
func _on_ctx_selection_changed(payload: Dictionary) -> void:
	match StringName(payload.get("type", "")):
		&"palette":
			var pl: Variant = payload["payload"]
			if pl is UnitData or pl is UnitSlotData:
				_start_place_unit_tool(pl)
		&"task_palette":
			_start_place_task_tool(payload["task"])
		&"trigger_palette":
			_start_place_trigger_tool(payload["prototype"])
		_:
			pass


## Open slot configuration dialog for a slot index
func _open_slot_config(index: int) -> void:
	if not ctx.data or not ctx.data.unit_slots:
		return
	_slot_cfg.show_for(self, index)


## Open unit configuration dialog for a unit index
func _open_unit_config(index: int) -> void:
	if not ctx.data or not ctx.data.units:
		return
	_unit_cfg.show_for(self, index)


## Open task configuration dialog for a task index
func _open_task_config(task_index: int) -> void:
	if not ctx.data or ctx.data.tasks == null:
		return
	var inst: ScenarioTask = ctx.data.tasks[task_index]
	_task_cfg.show_for(self, inst)


## Open trigger configuration dialog for a trigger index
func _open_trigger_config(index: int) -> void:
	if index < 0 or index >= ctx.data.triggers.size():
		return
	_trigger_cfg.show_for(self, index)


## Begin Task placement tool with a given task prototype
func _start_place_task_tool(task: UnitBaseTask) -> void:
	var tool := TaskPlaceTool.new()
	tool.task = task
	_set_tool(tool)


## Begin Unit/Slot placement tool with a given payload
func _start_place_unit_tool(payload: Variant) -> void:
	var tool := UnitPlaceTool.new()
	tool.payload = payload
	_set_tool(tool)


## Begin Trigger placement tool with a trigger prototype
func _start_place_trigger_tool(proto: ScenarioTrigger) -> void:
	var tool := ScenarioTriggerTool.new()
	tool.prototype = proto
	_set_tool(tool)


## Place a Unit at world position (meters) and push to history
func _place_unit_from_tool(u: UnitData, pos_m: Vector2) -> void:
	if ctx.data == null:
		push_warning("No active scenario")
		return
	var su := ScenarioUnit.new()
	su.unit = u
	su.position_m = pos_m
	su.affiliation = ctx.selected_unit_affiliation
	su.callsign = _generate_callsign(ctx.selected_unit_affiliation)
	su.id = _generate_unit_instance_id_for(u)
	if ctx.data.units == null:
		ctx.data.units = []
	history.push_res_insert(ctx.data, "units", "id", su, "Place Unit %s" % su.callsign)
	ctx.selected_pick = {"type": &"unit", "index": ctx.data.units.size() - 1}
	ctx.request_overlay_redraw()
	_rebuild_scene_tree()
	units._refresh(ctx)


## Place a player slot at world position (meters) and push to history
func _place_slot_from_tool(slot_def: UnitSlotData, pos_m: Vector2) -> void:
	if ctx.data == null:
		push_warning("No active scenario")
		return
	var callsign := _generate_callsign(ScenarioUnit.Affiliation.FRIEND)
	var inst := UnitSlotData.new()
	inst.key = _next_slot_key()
	inst.title = callsign
	inst.callsign = callsign
	inst.allowed_roles = slot_def.allowed_roles.duplicate()
	inst.start_position = pos_m
	if ctx.data.unit_slots == null:
		ctx.data.unit_slots = []
	history.push_res_insert(ctx.data, "unit_slots", "key", inst, "Place Slot %s" % inst.title)
	ctx.request_overlay_redraw()
	_rebuild_scene_tree()


## Place a Trigger at world position (meters) and push to history
func _place_trigger_from_tool(inst: ScenarioTrigger, pos_m: Vector2) -> void:
	if ctx.data == null:
		push_warning("No active scenario")
		return
	inst.id = _generate_trigger_id()
	inst.area_center_m = pos_m
	if inst.title.strip_edges() == "":
		inst.title = inst.id
	if ctx.data.triggers == null:
		ctx.data.triggers = []
	history.push_res_insert(ctx.data, "triggers", "id", inst, "Place Trigger %s" % inst.title)
	_rebuild_scene_tree()
	ctx.request_overlay_redraw()


## Set or clear current tool and wire its signals
func _set_tool(tool: ScenarioToolBase) -> void:
	if ctx.current_tool:
		ctx.current_tool.deactivate()
	ctx.current_tool = tool
	if tool:
		tool.activate(self)
		tool.build_hint_ui(tool_hint)
		tool.request_redraw_overlay.connect(func(): ctx.request_overlay_redraw())
		tool.finished.connect(func(): _clear_tool())
		tool.canceled.connect(func(): _clear_tool())
		ctx.request_overlay_redraw()
	else:
		_clear_hint()


## Clear current tool
func _clear_tool() -> void:
	LogService.trace("clear tool", "ScenarioEditor.gd:280")
	_set_tool(null)


## Remove all hint widgets from the hint bar
func _clear_hint() -> void:
	for n in tool_hint.get_children():
		n.queue_free()


## Handle overlay input: hover, drag, link, select, and tool input
func _on_overlay_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if ctx.data and ctx.data.terrain:
			var mp = terrain_render.map_to_terrain(event.position)
			var grid := terrain_render.pos_to_grid(mp)
			mouse_position_label.text = "(%d, %d | %s)" % [mp.x, mp.y, grid]
			terrain_overlay.on_mouse_move(event.position)
		if draglink.linking:
			draglink.update_link(ctx, event.position)
		elif draglink.dragging:
			draglink.update_drag(ctx, event.position)

	if ctx.current_tool and ctx.current_tool.handle_input(event):
		return

	if event is InputEventMouseButton:
		if not event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if draglink.linking:
					var dst := terrain_overlay.get_pick_at(event.position)
					draglink.end_link(ctx)
					ScenarioTriggersService.new().try_sync_link(ctx, draglink.link_src_pick, dst)
					return
				if draglink.dragging:
					draglink.end_drag(ctx, true)
					return
			return

		if event.button_index == MOUSE_BUTTON_RIGHT:
			if draglink.dragging:
				draglink.end_drag(ctx, false)
				return
			if draglink.linking:
				draglink.end_link(ctx)
				return
			terrain_overlay.on_ctx_open(event)
			return

		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.ctrl_pressed:
				var src := terrain_overlay.get_pick_at(event.position)
				if (
					not src.is_empty()
					and StringName(src.get("type", "")) in [&"unit", &"task", &"trigger"]
				):
					draglink.begin_link(ctx, src, event.position)
					return
			if event.double_click:
				terrain_overlay.on_dbl_click(event)
				return
			var pick := terrain_overlay.get_pick_at(event.position)
			if pick.is_empty():
				selection.clear_selection(ctx)
			else:
				selection.set_selection(ctx, pick)
				draglink.begin_drag(ctx, pick, event.position)
			return


## Global key handling: delete, undo/redo, and tool input
func _unhandled_key_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_DELETE:
		if not ctx.selected_pick.is_empty():
			_delete_pick(ctx.selected_pick)
			get_viewport().set_input_as_handled()
			return
	if event is InputEventKey and event.pressed:
		if event.ctrl_pressed and event.keycode == KEY_Z:
			if history:
				history.undo()
			get_viewport().set_input_as_handled()
			return
		if event.ctrl_pressed and event.keycode == KEY_Y:
			if history:
				history.redo()
			get_viewport().set_input_as_handled()
			return
	if ctx.current_tool and ctx.current_tool.handle_input(event):
		return


## Route deletion to the correct entity handler
func _delete_pick(pick: Dictionary) -> void:
	match StringName(pick.get("type", "")):
		&"unit":
			_delete_unit(int(pick["index"]))
		&"slot":
			_delete_slot(int(pick["index"]))
		&"task":
			_delete_task(int(pick["index"]))
		&"trigger":
			_delete_trigger(int(pick["index"]))
		_:
			pass


## Delete a unit and all its tasks; reindex references; push history
func _delete_unit(unit_index: int) -> void:
	if not ctx.data or not ctx.data.units:
		return
	if unit_index < 0 or unit_index >= ctx.data.units.size():
		return
	var before := _snapshot_arrays()
	var after := _snapshot_arrays()

	after["units"].remove_at(unit_index)

	var to_remove: Array[int] = []
	for i in (after["tasks"] as Array).size():
		var ti: ScenarioTask = (after["tasks"] as Array)[i]
		if ti and ti.unit_index == unit_index:
			to_remove.append(i)
	to_remove.sort()
	for i in range(to_remove.size() - 1, -1, -1):
		var inst: ScenarioTask = (after["tasks"] as Array)[to_remove[i]]
		if inst:
			var p := inst.prev_index
			var n := inst.next_index
			if p >= 0 and p < (after["tasks"] as Array).size():
				var prev: Variant = (after["tasks"] as Array)[p]
				if prev:
					prev.next_index = n
			if n >= 0 and n < (after["tasks"] as Array).size():
				var nxt: Variant = (after["tasks"] as Array)[n]
				if nxt:
					nxt.prev_index = p
		(after["tasks"] as Array).remove_at(to_remove[i])

	for t in after["tasks"] as Array:
		if t == null:
			continue
		if t.unit_index > unit_index:
			t.unit_index -= 1
		t.prev_index = clamp(t.prev_index, -1, (after["tasks"] as Array).size() - 1)
		t.next_index = clamp(t.next_index, -1, (after["tasks"] as Array).size() - 1)

	for trig in after["triggers"] as Array:
		if trig == null:
			continue
		if trig.synced_units != null:
			var outu: Array[int] = []
			for uidx in trig.synced_units:
				if uidx == unit_index:
					continue
				outu.append(uidx - 1 if uidx > unit_index else uidx)
			trig.synced_units = outu
		if trig.synced_tasks != null:
			var outt: Array[int] = []
			for tidx in trig.synced_tasks:
				if tidx >= 0 and tidx < (after["tasks"] as Array).size():
					outt.append(tidx)
			trig.synced_tasks = outt

	(
		history
		. push_multi_replace(
			ctx.data,
			[
				{"prop": "units", "before": before["units"], "after": after["units"]},
				{"prop": "tasks", "before": before["tasks"], "after": after["tasks"]},
				{"prop": "triggers", "before": before["triggers"], "after": after["triggers"]},
			],
			"Delete Unit"
		)
	)
	selection.clear_selection(ctx)
	ctx.request_overlay_redraw()
	_rebuild_scene_tree()
	units._refresh(ctx)


## Delete a slot; push history and refresh
func _delete_slot(slot_index: int) -> void:
	if not ctx.data or not ctx.data.unit_slots:
		return
	if slot_index < 0 or slot_index >= ctx.data.unit_slots.size():
		return
	var before := _snapshot_arrays()
	var after := _snapshot_arrays()
	(after["unit_slots"] as Array).remove_at(slot_index)
	history.push_array_replace(
		ctx.data, "unit_slots", before["unit_slots"], after["unit_slots"], "Delete Slot"
	)
	selection.clear_selection(ctx)
	ctx.request_overlay_redraw()
	_rebuild_scene_tree()


## Delete a task; repair chain links and reindex; push history
func _delete_task(task_index: int) -> void:
	if not ctx.data or not ctx.data.tasks:
		return
	if task_index < 0 or task_index >= ctx.data.tasks.size():
		return
	var before := _snapshot_arrays()
	var after := _snapshot_arrays()

	var all_tasks := after["tasks"] as Array
	var inst: ScenarioTask = all_tasks[task_index]
	if inst:
		var p := inst.prev_index
		var n := inst.next_index
		if p >= 0 and p < all_tasks.size():
			var prev: Variant = all_tasks[p]
			if prev:
				prev.next_index = n
		if n >= 0 and n < all_tasks.size():
			var nxt: Variant = all_tasks[n]
			if nxt:
				nxt.prev_index = p

	all_tasks.remove_at(task_index)
	for t in all_tasks:
		if t == null:
			continue
		if t.prev_index > task_index:
			t.prev_index -= 1
		if t.next_index > task_index:
			t.next_index -= 1

	for trig in after["triggers"] as Array:
		if trig == null or trig.synced_tasks == null:
			continue
		var out: Array[int] = []
		for i in trig.synced_tasks:
			if i == task_index:
				continue
			out.append(i - 1 if i > task_index else i)
		trig.synced_tasks = out

	(
		history
		. push_multi_replace(
			ctx.data,
			[
				{"prop": "tasks", "before": before["tasks"], "after": after["tasks"]},
				{"prop": "triggers", "before": before["triggers"], "after": after["triggers"]},
			],
			"Delete Task"
		)
	)
	selection.clear_selection(ctx)
	ctx.request_overlay_redraw()
	_rebuild_scene_tree()


## Delete a trigger; push history and refresh
func _delete_trigger(trigger_index: int) -> void:
	if not ctx.data or not ctx.data.triggers:
		return
	if trigger_index < 0 or trigger_index >= ctx.data.triggers.size():
		return
	var before := _snapshot_arrays()
	var after := _snapshot_arrays()
	(after["triggers"] as Array).remove_at(trigger_index)
	history.push_array_replace(
		ctx.data, "triggers", before["triggers"], after["triggers"], "Delete Trigger"
	)
	selection.clear_selection(ctx)
	ctx.request_overlay_redraw()
	_rebuild_scene_tree()


## File menu actions (New/Open/Save/Save As/Back)
func _on_filemenu_pressed(id: int):
	match id:
		0:
			new_scenario_dialog.show_dialog(true)
		1:
			_cmd_open()
		2:
			_cmd_save()
		3:
			_cmd_save_as()
		4:
			Game.goto_scene(MAIN_MENU_SCENE)


## Attributes menu actions (Edit Scenario/Briefing/Weather)
func _on_attributemenu_pressed(id: int):
	match id:
		0:
			if ctx.data:
				new_scenario_dialog.show_dialog(true, ctx.data)
			else:
				new_scenario_dialog.show_dialog(true)
		1:
			if ctx.data == null:
				var acc := AcceptDialog.new()
				acc.title = "Briefing"
				acc.dialog_text = "Create a scenario first."
				add_child(acc)
				acc.popup_centered()
				return
			brief_dialog.show_dialog(true, ctx.data.briefing)
		2:
			if ctx.data == null:
				var acc := AcceptDialog.new()
				acc.title = "Weather"
				acc.dialog_text = "Create a scenario first."
				add_child(acc)
				acc.popup_centered()
				return
			weather_dialog.show_dialog(true)


## Save to current path or fallback to Save As
func _cmd_save() -> void:
	if _current_path.strip_edges() == "":
		_cmd_save_as()
		return
	if ctx.data == null:
		_show_info("No scenario to save.")
		return
	if persistence.save_to_path(ctx, _current_path):
		_dirty = false
		_show_info("Saved: %s" % _current_path)


## Show Save As dialog with suggested filename
func _cmd_save_as() -> void:
	if ctx.data == null:
		_show_info("No scenario to save.")
		return
	_save_dlg.current_file = persistence.suggest_filename(ctx)
	_save_dlg.popup_centered_ratio(0.75)


## Show Open dialog (asks to discard if dirty)
func _cmd_open() -> void:
	if _dirty and not await _confirm_discard():
		return
	_open_dlg.popup_centered_ratio(0.75)


## Handle file selection to open a scenario
func _on_open_file_selected(path: String) -> void:
	if persistence.load_from_path(ctx, path):
		_current_path = path
		_dirty = false
		_on_data_changed()
	else:
		_show_info("Failed to open: %s" % path)


## Handle file selection to save a scenario
func _on_save_file_selected(path: String) -> void:
	var fixed := persistence.ensure_json_ext(path)
	if persistence.save_to_path(ctx, fixed):
		_current_path = fixed
		_dirty = false
		_show_info("Saved: %s" % fixed)
	else:
		_show_info("Failed to save: %s" % fixed)


## Apply brand-new scenario data from dialog
func _on_new_scenario(d: ScenarioData) -> void:
	ctx.data = d
	_current_path = ""
	_dirty = false
	_on_data_changed()

	if is_instance_valid(history):
		remove_child(history)
	history = ScenarioHistory.new()
	add_child(history)
	ctx.history = history
	history.history_changed.connect(_on_history_changed)


## Apply edits to current scenario data from dialog
func _on_update_scenario(_d: ScenarioData) -> void:
	_on_data_changed()


## Apply briefing change via history (undoable).
func _on_briefing_update(new_brief: BriefData) -> void:
	if ctx.data == null:
		return
	var before := ctx.data.briefing
	var label := "Create Briefing" if before == null else "Update Briefing"
	history.push_prop_set(ctx.data, "briefing", before, new_brief, label)
	_dirty = true
	_on_data_changed()


## Refresh UI/overlay/tree after data changes
func _on_data_changed() -> void:
	title_label.text = ctx.data.title
	if ctx.data and ctx.data.terrain:
		terrain_render.data = ctx.data.terrain
	else:
		mouse_position_label.text = ""
	ctx.request_overlay_redraw()
	_rebuild_scene_tree()
	_on_history_changed([], [])
	units._refresh(ctx)


## Update window title label from scenario title
func _update_title() -> void:
	title_label.text = ctx.data.title if ctx.data else "Scenario"


## Rebuild history side panel from UndoRedo stacks
func _on_history_changed(past: Array, future: Array) -> void:
	for n in history_list.get_children():
		n.queue_free()
	for i in range(past.size()):
		var row := HBoxContainer.new()
		var txt := Label.new()
		txt.text = str(past[i])
		if i == past.size() - 1:
			txt.add_theme_color_override("font_color", Color(1, 1, 1))
			txt.add_theme_font_size_override("font_size", 14)
		row.add_child(txt)
		history_list.add_child(row)
	for i in range(future.size() - 1, -1, -1):
		var row2 := HBoxContainer.new()
		var arrow := Label.new()
		arrow.text = "↻ "
		var txt2 := Label.new()
		txt2.text = str(future[i])
		txt2.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
		row2.add_child(arrow)
		row2.add_child(txt2)
		history_list.add_child(row2)
	units._refresh(ctx)


## Generate next unique slot key (SLOT_n)
func _next_slot_key() -> String:
	var n := 1
	if ctx.data and ctx.data.unit_slots:
		n = ctx.data.unit_slots.size() + 1
	return "SLOT_%d" % n


## Generate next unique trigger id (TRG_n)
func _generate_trigger_id() -> String:
	var used := {}
	if ctx.data and ctx.data.triggers:
		for t in ctx.data.triggers:
			if t and t.id is String and (t.id as String).begins_with("TRG_"):
				var s := (t.id as String).substr(4)
				if s.is_valid_int():
					used[int(s)] = true
	var n := 1
	while used.has(n):
		n += 1
	return "TRG_%d" % n


## Compute next available callsign for given affiliation
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


## Get callsign pool for faction (uses defaults if scenario lacks overrides)
func _get_callsign_pool(affiliation: ScenarioUnit.Affiliation) -> Array[String]:
	var pool: Array[String]
	if affiliation == ScenarioUnit.Affiliation.FRIEND:
		if data and data.friendly_callsigns and data.friendly_callsigns.size() > 0:
			pool = data.friendly_callsigns
		else:
			pool = DEFAULT_FRIENDLY_CALLSIGNS
	else:
		if data and data.enemy_callsigns and data.enemy_callsigns.size() > 0:
			pool = data.enemy_callsigns
		else:
			pool = DEFAULT_ENEMY_CALLSIGNS
	var out: Array[String] = []
	for v in pool:
		out.append(str(v))
	return out


## Build set of already-used callsigns for uniqueness checks
func _collect_used_callsigns(affiliation: ScenarioUnit.Affiliation) -> Dictionary:
	var used := {}
	if ctx.data == null:
		return used
	if ctx.data.units:
		for su in ctx.data.units:
			if su and su.affiliation == affiliation:
				var cs := String(su.callsign).strip_edges()
				if not cs.is_empty():
					used[cs] = true
	if ctx.data.unit_slots and affiliation == ScenarioUnit.Affiliation.FRIEND:
		for s in ctx.data.unit_slots:
			if s:
				var title := String(s.title).strip_edges()
				if not title.is_empty():
					used[title] = true
	return used


## Generate unique unit instance id based on UnitData.id
func _generate_unit_instance_id_for(u: UnitData) -> String:
	var base := String(u.id)
	if base.is_empty():
		base = "unit"
	var used := {}
	if ctx.data and ctx.data.units:
		var prefix := base + "_"
		for su in ctx.data.units:
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


## Confirm discarding unsaved changes; returns true if accepted
func _confirm_discard() -> bool:
	var acc := ConfirmationDialog.new()
	acc.title = "Unsaved changes"
	acc.dialog_text = "You have unsaved changes. Discard and continue?"
	add_child(acc)
	var accepted := false
	@warning_ignore("confusable_capture_reassignment") acc.canceled.connect(func(): accepted = false)
	@warning_ignore("confusable_capture_reassignment") acc.confirmed.connect(func(): accepted = true)
	acc.popup_centered()
	await acc.confirmed
	acc.queue_free()
	return accepted


## Show a non-blocking info toast/dialog with a message
func _show_info(msg: String) -> void:
	var d := AcceptDialog.new()
	d.title = "Info"
	d.dialog_text = msg
	add_child(d)


## Deep-copy key arrays for history operations
func _snapshot_arrays() -> Dictionary:
	return {
		"units":
		ScenarioHistory._deep_copy_array_res(ctx.data.units if ctx.data and ctx.data.units else []),
		"unit_slots":
		ScenarioHistory._deep_copy_array_res(
			ctx.data.unit_slots if ctx.data and ctx.data.unit_slots else []
		),
		"tasks":
		ScenarioHistory._deep_copy_array_res(ctx.data.tasks if ctx.data and ctx.data.tasks else []),
		"triggers":
		ScenarioHistory._deep_copy_array_res(
			ctx.data.triggers if ctx.data and ctx.data.triggers else []
		),
	}


## Utility: queue_free all children of a UI container
func _queue_free_children(node: Control):
	for n in node.get_children():
		n.queue_free()
