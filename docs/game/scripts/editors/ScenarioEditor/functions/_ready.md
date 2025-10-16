# ScenarioEditor::_ready Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 121–178)</br>
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
```
