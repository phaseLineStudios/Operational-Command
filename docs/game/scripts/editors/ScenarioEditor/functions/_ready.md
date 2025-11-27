# ScenarioEditor::_ready Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 80–170)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _ready()
```

## Description

Initialize context, services, signals, UI, and dialogs

## Source

```gdscript
func _ready():
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
```
