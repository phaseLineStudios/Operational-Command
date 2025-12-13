class_name ScenarioEditor
extends Control

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

var draw_tools := ScenarioEditorDrawTools.new()
var file_ops := ScenarioEditorFileOps.new()
var id_gen := ScenarioEditorIDGenerator.new()
var deletion_ops := ScenarioEditorDeletionOps.new()
var menus := ScenarioEditorMenus.new()

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
@onready var units_add_btn: Button = %NewUnit
@onready var unit_create_dialog: UnitCreateDialog = %UnitCreateDialog

@onready var task_list: ItemList = %Tasks
@onready var trigger_list: ItemList = %Triggers
@onready var command_list: ItemList = %Commands
@onready var new_command_btn: Button = %NewCommand
@onready var edit_command_btn: Button = %EditCommand
@onready var delete_command_btn: Button = %DeleteCommand

@onready var draw_toolbar_freehand: Button = %BtnFreehand
@onready var draw_toolbar_stamp: Button = %BtnStamp
@onready var draw_toolbar_eraser: Button = %BtnEraser
@onready var fh_settings: GridContainer = %FHSettings
@onready var fh_color: ColorPickerButton = %FHColor
@onready var fh_width: SpinBox = %FHWidth
@onready var fh_opacity: HSlider = %FHOpacity
@onready var st_settings: GridContainer = %STSettings
@onready var st_seperator: HSeparator = %STSeperator
@onready var st_color: ColorPickerButton = %STColor
@onready var st_scale: SpinBox = %STScale
@onready var st_rotation: SpinBox = %STRotation
@onready var st_opacity: HSlider = %STOpacity
@onready var st_label_text: LineEdit = %STLabelText
@onready var st_label: Label = %STLabel
@onready var st_list: ItemList = %STList
@onready var st_load_btn: Button = %LoadTexture

@onready var slot_cfg: SlotConfigDialog = %SlotConfigDialog
@onready var unit_cfg: UnitConfigDialog = %UnitConfigDialog
@onready var task_cfg: TaskConfigDialog = %TaskConfigDialog
@onready var trigger_cfg: TriggerConfigDialog = %TriggerConfigDialog
@onready var command_cfg: CustomCommandConfigDialog = %CustomCommandConfigDialog

@onready var _tab_container1: TabContainer = %TabContainer1


## Initialize context, services, signals, UI, and dialogs
func _ready():
	AudioManager.stop_music(0.5)

	# Initialize helper classes
	draw_tools.init(self)
	file_ops.init(self)
	id_gen.init(self)
	deletion_ops.init(self)
	menus.init(self)

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
	ctx.unit_create_btn = units_add_btn
	ctx.unit_create_dlg = unit_create_dialog

	ctx.task_list = task_list
	ctx.trigger_list = trigger_list

	ctx.overlay_redraw_requested.connect(func(): terrain_overlay.request_redraw())
	ctx.scene_tree_rebuild_requested.connect(func(): _rebuild_scene_tree())
	ctx.toast_requested.connect(func(msg): file_ops._show_info(msg))
	ctx.selection_changed.connect(_on_ctx_selection_changed)

	file_menu.get_popup().connect("id_pressed", menus.on_filemenu_pressed)
	attribute_menu.get_popup().connect("id_pressed", menus.on_attributemenu_pressed)

	new_scenario_dialog.request_create.connect(file_ops.on_new_scenario)
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
	_update_title()

	# fix tab container name
	_tab_container1.set_tab_title(0, "Scene Tree")

	draw_toolbar_freehand.pressed.connect(draw_tools.on_draw_click_freehand)
	draw_toolbar_stamp.pressed.connect(draw_tools.on_draw_click_stamp)
	draw_toolbar_eraser.pressed.connect(draw_tools.on_draw_click_eraser)

	fh_color.color_changed.connect(func(_c): draw_tools.sync_freehand_opts())
	fh_width.value_changed.connect(func(_v): draw_tools.sync_freehand_opts())
	fh_opacity.value_changed.connect(func(_v): draw_tools.sync_freehand_opts())

	st_scale.value_changed.connect(func(_v): draw_tools.sync_stamp_opts())
	st_color.color_changed.connect(func(_c): draw_tools.sync_stamp_opts())
	st_rotation.value_changed.connect(func(_v): draw_tools.sync_stamp_opts())
	st_opacity.value_changed.connect(func(_v): draw_tools.sync_stamp_opts())
	st_label_text.text_changed.connect(func(_t): draw_tools.sync_stamp_opts())
	st_list.item_selected.connect(draw_tools.on_stamp_selected)
	st_load_btn.pressed.connect(draw_tools.on_stamp_load_clicked)

	# Custom command list signals
	command_list.item_activated.connect(func(idx: int): menus.open_command_config(idx))
	new_command_btn.pressed.connect(_on_new_command)
	edit_command_btn.pressed.connect(_on_edit_command)
	delete_command_btn.pressed.connect(_on_delete_command)
	command_cfg.saved.connect(func(_idx: int, _cmd: CustomCommand): _rebuild_command_list())

	draw_tools.build_stamp_pool()


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
	su.callsign = id_gen.generate_callsign(ctx.selected_unit_affiliation)
	su.id = id_gen.generate_unit_instance_id_for(u)
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
	var callsign := id_gen.generate_callsign(ScenarioUnit.Affiliation.FRIEND)
	var inst := UnitSlotData.new()
	inst.key = id_gen.next_slot_key()
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
	inst.id = id_gen.generate_trigger_id()
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
	# Clear all draw tool button states
	draw_toolbar_freehand.set_pressed_no_signal(false)
	draw_toolbar_stamp.set_pressed_no_signal(false)
	draw_toolbar_eraser.set_pressed_no_signal(false)


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
					ScenarioTriggersService.new().try_sync_link(ctx, draglink.link_src_pick, dst)
					draglink.end_link(ctx)
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
					LogService.trace(
						"BeginDrag: \n%s" % JSON.stringify(src), "ScenarioEditor.gd:416"
					)
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
				LogService.trace("BeginDrag: \n%s" % JSON.stringify(pick), "ScenarioEditor.gd:427")
				draglink.begin_drag(ctx, pick, event.position)
			return


## Global key handling: delete, undo/redo, and tool input
func _unhandled_key_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_DELETE:
		if not ctx.selected_pick.is_empty():
			deletion_ops.delete_pick(ctx.selected_pick)
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
	file_ops.mark_dirty()
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
	_rebuild_command_list()
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
	ctx.request_overlay_redraw()


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
			pool = ScenarioEditorIDGenerator.DEFAULT_FRIENDLY_CALLSIGNS
	else:
		if data and data.enemy_callsigns and data.enemy_callsigns.size() > 0:
			pool = data.enemy_callsigns
		else:
			pool = ScenarioEditorIDGenerator.DEFAULT_ENEMY_CALLSIGNS
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
	@warning_ignore("confusable_capture_reassignment")
	acc.canceled.connect(func(): accepted = false)
	@warning_ignore("confusable_capture_reassignment")
	acc.confirmed.connect(func(): accepted = true)
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


## Rebuild the custom commands list from scenario data
func _rebuild_command_list() -> void:
	command_list.clear()
	if not ctx.data:
		return
	for cmd in ctx.data.custom_commands:
		if cmd is CustomCommand:
			var text := cmd.keyword if cmd.keyword != "" else "(empty)"
			command_list.add_item(text)


## Create a new custom command
func _on_new_command() -> void:
	if not ctx.data:
		return
	var cmd := CustomCommand.new()
	cmd.keyword = "new_command"

	if history:
		var before := ctx.data.custom_commands.duplicate(true)
		var after := before.duplicate(true)
		after.append(cmd)
		history.push_array_replace(ctx.data, "custom_commands", before, after, "Add Custom Command")
	else:
		ctx.data.custom_commands.append(cmd)

	_rebuild_command_list()
	# Select and open the new command
	var idx := ctx.data.custom_commands.size() - 1
	command_list.select(idx)
	menus.open_command_config(idx)


## Edit the selected custom command
func _on_edit_command() -> void:
	var selected := command_list.get_selected_items()
	if selected.is_empty():
		return
	menus.open_command_config(selected[0])


## Delete the selected custom command
func _on_delete_command() -> void:
	var selected := command_list.get_selected_items()
	if selected.is_empty():
		return
	deletion_ops.delete_command(selected[0])
