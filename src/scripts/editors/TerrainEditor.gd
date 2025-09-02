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

@onready var file_menu: MenuButton = %File
@onready var tools_grid: GridContainer = %Tools
@onready var terrain_render: TerrainRender = %World
@onready var terrainview_container: SubViewportContainer = %TerrainView
@onready var terrainview: SubViewport = %TerrainView/View
@onready var brush_overlay: Control = %BrushOverlay
@onready var new_terrain_dialog: NewTerrainDialog = %NewTerrainDialog
@onready var tools_options: VBoxContainer = %"Tool Options"
@onready var tools_info: VBoxContainer = %"Tool Info"
@onready var camera: TerrainCamera = %Camera

var brushes: Array[TerrainBrush] = []
var features: Array[Variant] = []

var tool_map := {}
var active_tool: TerrainToolBase
var _inside_brush_overlay := false

const TOOL_ORDER := [
	"res://scripts/editors/tools/TerrainElevationTool.gd",
	"res://scripts/editors/tools/TerrainPolygonTool.gd"
]

const MAIN_MENU_SCENE := "res://scenes/main_menu.tscn"

func _ready():
	file_menu.get_popup().connect("id_pressed", _on_filemenu_pressed)
	new_terrain_dialog.connect("request_create", _new_terrain)
	brush_overlay.mouse_entered.connect(_on_brush_overlay_mouse_enter)
	brush_overlay.mouse_exited.connect(_on_brush_overlay_mouse_exit)
	brush_overlay.gui_input.connect(_on_brush_overlay_gui_input)
	terrain_render.map_resize.connect(_on_terrain_resize)
	terrain_render.data = data
	_build_tool_buttons()

## On filemenu pressed event
func _on_filemenu_pressed(id: int):
	match id:
		0: _on_new_pressed()
		4: _quit_editor()

## On New Terrain Pressed event
func _on_new_pressed():
	new_terrain_dialog.show_dialog(true)

## Create new terrain data
func _new_terrain(d: TerrainData):
	data = d
	terrain_render.data = d
	
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
		tool.on_need_info.connect(_rebuild_info_panel)
		
		var btn := TextureButton.new()
		btn.ignore_texture_size = true
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		btn.custom_minimum_size = tool_icon_size
		btn.toggle_mode = true
		tool_map[btn] = tool
		btn.tooltip_text = tool.tool_hint
		btn.texture_normal = tool.tool_icon
		tools_grid.add_child(btn)
		
		btn.pressed.connect(func():
			_select_tool(btn)
		)

## Select the active tool
func _select_tool(btn: TextureButton) -> void:
	if active_tool:
		active_tool.destroy_preview()
		
	for n in tools_grid.get_children():
		if n is Button:
			n.button_pressed = (n == btn)
	active_tool = tool_map[btn]
	_rebuild_options_panel()
	_rebuild_info_panel()
	if active_tool:
		active_tool.ensure_preview(brush_overlay)

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

## Handle input
func _input(event: InputEvent) -> void:
	if active_tool and active_tool.handle_view_input(event):
		return

## Input handler for terrainview Viewport
func _on_brush_overlay_gui_input(event):
	if event is InputEventMouseMotion && active_tool:
		active_tool.on_mouse_inside(_inside_brush_overlay)
		if not _inside_brush_overlay:
			return
		
		active_tool.update_preview_at_overlay(brush_overlay, event.position)

## Triggers when mouse enters brush overlay
func _on_brush_overlay_mouse_enter():
	_inside_brush_overlay = true

## Triggers when mouse exits brush overlay
func _on_brush_overlay_mouse_exit():
	_inside_brush_overlay = false

func _on_terrain_resize():
	brush_overlay.position = terrain_render.get_map_position()
	brush_overlay.size = terrain_render.get_map_size()

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
func screen_to_terrain(pos: Vector2, keep_aspect: bool = true) -> Vector2:
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
func terrain_to_screen(local_m: Vector2, keep_aspect: bool = true) -> Vector2:
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
