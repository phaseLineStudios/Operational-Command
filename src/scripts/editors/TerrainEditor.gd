extends Control
class_name TerrainEditor
## In-game terrain editor for custom terrains.
##
## Lets creators create terrains to use in scenarios.

## Initial Terrain Data
@export var data: TerrainData

@export_group("Tools")
## Icon size for tool buttons
@export var tool_icon_size: Vector2 = Vector2(25, 25)

@onready var history := TerrainHistory.new()
@onready var file_menu: MenuButton = %File
@onready var edit_menu: MenuButton = %Edit
@onready var tools_grid: GridContainer = %Tools
@onready var terrain_render: TerrainRender = %World
@onready var terrainview_container: SubViewportContainer = %TerrainView
@onready var terrainview: SubViewport = %TerrainView/View
@onready var brush_overlay: Control = %BrushOverlay
@onready var terrain_settings_dialog: NewTerrainDialog = %TerrainSettingsDialog
@onready var tools_options: VBoxContainer = %"Tool Options"
@onready var tools_info: VBoxContainer = %"Tool Info"
@onready var tools_hint: HBoxContainer = %"ToolHint"
@onready var history_container: VBoxContainer = %History
@onready var camera: TerrainCamera = %Camera
@onready var mouse_position_l: Label = %MousePosition

var brushes: Array[TerrainBrush] = []
var features: Array[Variant] = []

var tool_map := {}
var active_tool: TerrainToolBase
var _inside_brush_overlay := false
var _current_path: String = ""

const TOOL_ORDER := [
	"res://scripts/editors/tools/TerrainElevationTool.gd",
	"res://scripts/editors/tools/TerrainPolygonTool.gd",
	"res://scripts/editors/tools/TerrainLineTool.gd",
	"res://scripts/editors/tools/TerrainPointTool.gd",
	"res://scripts/editors/tools/TerrainLabelTool.gd"
]

const MAIN_MENU_SCENE := "res://scenes/main_menu.tscn"

func _ready():
	file_menu.get_popup().connect("id_pressed", _on_filemenu_pressed)
	edit_menu.get_popup().connect("id_pressed", _on_editmenu_pressed)
	terrain_settings_dialog.connect("request_create", _new_terrain)
	terrain_settings_dialog.connect("request_edit", _edit_terrain)
	terrain_settings_dialog.editor = self
	brush_overlay.mouse_entered.connect(_on_brush_overlay_mouse_enter)
	brush_overlay.mouse_exited.connect(_on_brush_overlay_mouse_exit)
	brush_overlay.gui_input.connect(_on_brush_overlay_gui_input)
	terrain_render.data = data
	_build_tool_buttons()
	
	history.history_changed.connect(_on_history_changed)
	_on_history_changed([], [])

## On file menu pressed event
func _on_filemenu_pressed(id: int):
	match id:
		0: _on_new_pressed()
		1: _open()
		2: _save()
		3: _save_as()
		4: _quit_editor()
		
## On edit menu pressed event
func _on_editmenu_pressed(id: int):
	match id:
		0: terrain_settings_dialog.open_for_edit(data)
		1: history.undo()
		2: history.redo()

## On New Terrain Pressed event
func _on_new_pressed():
	terrain_settings_dialog.open_for_create("New Terrain", 2000, 2000, 100, 100, 113)

## Create new terrain data
func _new_terrain(d: TerrainData):
	data = d
	terrain_render.data = d
	
	for tool: TerrainToolBase in tool_map.values():
		tool.data = data

## Create new terrain data
func _edit_terrain(_d: TerrainData):
	terrain_render.data = data
	
	for tool: TerrainToolBase in tool_map.values():
		tool.data = data

## Quit editor and return to main menu
func _quit_editor():
	Game.goto_scene(MAIN_MENU_SCENE)

## Build the tool panel
func _build_tool_buttons():
	for tool_script in TOOL_ORDER:
		var s := load(tool_script) as Script
		var tool: TerrainToolBase = TerrainToolBase.new()
		tool.set_script(s)
		tool.editor = self
		tool.render = terrain_render
		tool.viewport_container = terrainview_container
		tool.viewport = terrainview
		tool.data = data
		tool.brushes = brushes
		tool.features = features
		tool.on_options_changed.connect(_rebuild_options_panel)
		tool.on_hints_changed.connect(_rebuild_tool_hint)
		tool.on_need_info.connect(_rebuild_info_panel)
		
		var btn := TextureButton.new()
		btn.ignore_texture_size = true
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		btn.custom_minimum_size = tool_icon_size
		btn.toggle_mode = true
		tool_map[btn] = tool
		btn.tooltip_text = tool.tool_hint
		btn.texture_normal = tool.tool_icon
		btn.self_modulate = Color(1, 1, 1, 0.4)
		btn.set_meta("hovered", false)
		tools_grid.add_child(btn)
		
		btn.mouse_entered.connect(func ():
			btn.set_meta("hovered", true)
			_update_tool_button_tint(btn)
		)
		btn.mouse_exited.connect(func ():
			btn.set_meta("hovered", false)
			_update_tool_button_tint(btn)
		)
		btn.focus_entered.connect(func ():
			btn.set_meta("hovered", true)
			_update_tool_button_tint(btn)
		)
		btn.focus_exited.connect(func ():
			btn.set_meta("hovered", false)
			_update_tool_button_tint(btn)
		)
		btn.toggled.connect(func (pressed: bool):
			_update_tool_button_tint(btn)
			if pressed:
				_select_tool(btn)
			else:
				_deselect_tool(btn)
		)

## Select the active tool
func _select_tool(btn: TextureButton) -> void:
	if active_tool:
		active_tool.destroy_preview()
		
	for n in tools_grid.get_children():
		if n is TextureButton:
			n.button_pressed = (n == btn)
			_update_tool_button_tint(n)
	
	active_tool = tool_map[btn]
	_rebuild_options_panel()
	_rebuild_info_panel()
	_rebuild_tool_hint()
	if active_tool:
		active_tool.ensure_preview(brush_overlay)

## Deselect the active tool
func _deselect_tool(_btn: TextureButton) -> void:
	if active_tool:
		active_tool.destroy_preview()
		active_tool = null

	for n in tools_grid.get_children():
		if n is TextureButton:
			n.button_pressed = false
			_update_tool_button_tint(n)

	_rebuild_options_panel()
	_rebuild_info_panel()
	_rebuild_tool_hint()

## Update tool button tint
func _update_tool_button_tint(btn: TextureButton) -> void:
	var hovered := bool(btn.get_meta("hovered", false))
	if btn.button_pressed or hovered:
		btn.self_modulate = Color(1, 1, 1, 1.0)  # fully visible
	else:
		btn.self_modulate = Color(1, 1, 1, 0.4)  # dimmed idle

## Rebuild the options panel for the selected tool
func _rebuild_options_panel() -> void:
	_queue_free_children(tools_options)
	if active_tool:
		active_tool.build_options_ui(tools_options)

## Builds the tool info panel
func _rebuild_info_panel() -> void:
	_queue_free_children(tools_info)
	if active_tool:
		active_tool.build_info_ui(tools_info)
		
## Builds the tool info panel
func _rebuild_tool_hint() -> void:
	_queue_free_children(tools_hint)
	if active_tool:
		active_tool.build_hint_ui(tools_hint)

## Handle unhandled input
func _unhandled_key_input(event):
	if active_tool and active_tool.handle_view_input(event):
		return
		
	if event is InputEventKey and event.pressed:
		var ctrl: bool = event.ctrl_pressed or event.meta_pressed
		if ctrl and event.keycode == KEY_Z:
			history.undo();
			accept_event()
		elif ctrl and (event.keycode == KEY_Y or (event.shift_pressed and event.keycode == KEY_Z)):
			history.redo(); 
			accept_event()
		elif ctrl and event.keycode == KEY_S:
			if event.shift_pressed: _save_as()
			else: _save()
			accept_event()
		elif ctrl and event.keycode == KEY_O:
			_open()
			accept_event()

## Input handler for terrainview Viewport
func _on_brush_overlay_gui_input(event):
	if event is InputEventMouseMotion:
		var mp: Vector2 = event.position
		mouse_position_l.text = "(%d, %d)" % [mp.x, mp.y]
	
	if event is InputEventMouseMotion && active_tool:
		active_tool.on_mouse_inside(_inside_brush_overlay)
		if not _inside_brush_overlay:
			return
		
		active_tool.update_preview_at_overlay(brush_overlay, event.position)
		
	if active_tool and active_tool.handle_view_input(event):
		return

## Triggers when mouse enters brush overlay
func _on_brush_overlay_mouse_enter():
	_inside_brush_overlay = true

## Triggers when mouse exits brush overlay
func _on_brush_overlay_mouse_exit():
	_inside_brush_overlay = false

## Save terrain
func _save():
	if data == null: 
		return
	if _current_path == "":
		_save_as(); return
	var err := ResourceSaver.save(data, _current_path)
	if err != OK:
		push_error("Save failed: %s" % err)

## Save terrain as
func _save_as():
	if data == null: 
		return
	var dlg := FileDialog.new()
	dlg.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	dlg.access = FileDialog.ACCESS_FILESYSTEM
	dlg.add_filter("*.tres ; Text Resource")
	dlg.add_filter("*.res ; Binary Resource")
	add_child(dlg)
	dlg.popup_centered_ratio(0.5)
	dlg.file_selected.connect(func(path):
		var err := ResourceSaver.save(data, path)
		if err == OK:
			_current_path = path
		else:
			push_error("Save As failed: %s" % err)
		dlg.queue_free()
	)
	dlg.canceled.connect(func(): dlg.queue_free())

## Open terrain
func _open():
	var dlg := FileDialog.new()
	dlg.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dlg.access = FileDialog.ACCESS_FILESYSTEM
	dlg.add_filter("*.tres, *.res ; TerrainData")
	add_child(dlg)
	dlg.popup_centered_ratio(0.5)
	dlg.file_selected.connect(func(path):
		var res := ResourceLoader.load(path)
		if res is TerrainData:
			_new_terrain(res)
		else:
			push_error("Not a TerrainData: %s" % path)
		dlg.queue_free()
	)
	dlg.canceled.connect(func(): dlg.queue_free())

## Show UndoRedo history
func _on_history_changed(past: Array, future: Array) -> void:
	_queue_free_children(history_container)

	for i in range(past.size()):
		var row := HBoxContainer.new()
		var txt := Label.new()
		txt.text = str(past[i])
		if i == past.size() - 1:
			txt.add_theme_color_override("font_color", Color(1, 1, 1))
			txt.add_theme_font_size_override("font_size", 14)
		row.add_child(txt)
		history_container.add_child(row)

	for i in range(future.size() - 1, -1, -1):
		var row2 := HBoxContainer.new()
		var arrow := Label.new()
		arrow.text = "↻ "
		var txt2 := Label.new()
		txt2.text = str(future[i])
		txt2.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
		row2.add_child(arrow)
		row2.add_child(txt2)
		history_container.add_child(row2)

## Helper function to delete all children of a parent node
func _queue_free_children(node: Control):
	for n in node.get_children():
		n.queue_free()

## API to get screen position from world position
func screen_to_world(pos: Vector2) -> Vector2:
	return (pos - terrain_render.global_position) / camera.zoom + camera.position

## API to get world position from screen position
func world_to_screen(pos: Vector2) -> Vector2:
	return (pos - camera.position) * camera.zoom + terrain_render.global_position

## API to convert a screen-space point to terrain-local meters,
func screen_to_map(pos: Vector2, keep_aspect: bool = true) -> Vector2:
	var sv := terrainview
	if sv == null:
		return Vector2.INF

	var cont_rect := terrainview_container.get_global_rect()
	var sv_size: Vector2 = sv.size

	var draw_pos: Vector2
	var p_scale: Vector2
	if keep_aspect:
		var s: float = min(cont_rect.size.x / sv_size.x, cont_rect.size.y / sv_size.y)
		var draw_size: Vector2 = sv_size * s
		draw_pos = cont_rect.position + (cont_rect.size - draw_size) * 0.5
		p_scale = Vector2(s, s)
	else:
		draw_pos = cont_rect.position
		p_scale = Vector2(cont_rect.size.x / sv_size.x, cont_rect.size.y / sv_size.y)

	var sv_pos := (pos - draw_pos) / p_scale

	var to_local_xform := terrain_render.get_global_transform_with_canvas().affine_inverse()
	var local_px := to_local_xform * sv_pos

	return local_px

## API to convert terrain meters to a screen-space point
func map_to_screen(local_m: Vector2, keep_aspect: bool = true) -> Vector2:
	var sv := terrainview
	if sv == null:
		return Vector2.INF
	if not local_m.is_finite():
		return Vector2.INF

	var cont_rect := terrainview_container.get_global_rect()
	var sv_size: Vector2 = sv.size

	var draw_pos: Vector2
	var p_scale: Vector2
	if keep_aspect:
		var s: float = min(cont_rect.size.x / sv_size.x, cont_rect.size.y / sv_size.y)
		var draw_size: Vector2 = sv_size * s
		draw_pos = cont_rect.position + (cont_rect.size - draw_size) * 0.5
		p_scale = Vector2(s, s)
	else:
		draw_pos = cont_rect.position
		p_scale = Vector2(cont_rect.size.x / sv_size.x, cont_rect.size.y / sv_size.y)

	var from_local_xform := terrain_render.get_global_transform_with_canvas()
	var sv_pos := from_local_xform * local_m

	var screen_pos := draw_pos + sv_pos * p_scale
	return screen_pos

## Helper function to convert terrain position to map position
func terrain_to_map(local_m: Vector2) -> Vector2:
	var map_margins := Vector2(terrain_render.margin_left_px, terrain_render.margin_top_px)
	return local_m - map_margins

## helepr function to convert map position to terrain position
func map_to_terrain(pos: Vector2) -> Vector2:
	var map_margins := Vector2(terrain_render.margin_left_px, terrain_render.margin_top_px)
	return pos + map_margins
