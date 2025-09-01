extends Control
class_name TerrainEditor
## In-game terrain editor for custom terrains.
##
## Lets creators create terrains to use in scenarios.

@export_group("Tools")
@export var tool_icon_size: Vector2 = Vector2(25, 25)

@onready var file_menu: MenuButton = %File
@onready var tools_grid: GridContainer = %Tools
@onready var terrain_render: TerrainRender = %World
@onready var new_terrain_dialog: NewTerrainDialog = %NewTerrainDialog

var data: TerrainData
var brushes: Array[TerrainBrush] = []
var features: Array[Variant] = []

var tool_map := {}
var active_tool: TerrainToolBase

const TOOL_ORDER := [
	"res://scripts/editors/tools/TerrainElevationTool.gd"
]

const MAIN_MENU_SCENE := "res://scenes/main_menu.tscn"

func _ready():
	file_menu.get_popup().connect("id_pressed", _on_filemenu_pressed)
	new_terrain_dialog.connect("request_create", _new_terrain)
	_build_tool_buttons()

func _on_filemenu_pressed(id: int):
	match id:
		0: _on_new_pressed()
		4: _quit_editor()

func _on_new_pressed():
	new_terrain_dialog.show_dialog(true)

func _new_terrain(d: TerrainData):
	data = d
	terrain_render.data = d

func _quit_editor():
	Game.goto_scene(MAIN_MENU_SCENE)

func _build_tool_buttons():
	tools_grid.columns = 2
	tools_grid.add_theme_constant_override("h_separation", 6)
	tools_grid.add_theme_constant_override("v_separation", 6)
	for tool_script in TOOL_ORDER:
		var s := load(tool_script) as Script
		var tool: TerrainToolBase = TerrainToolBase.new()
		tool.set_script(s)
		tool.editor = self
		tool.render = terrain_render
		tool.data = data
		tool.brushes = brushes
		tool.features = features
		#tool.on_options_changed.connect(_rebuild_options_panel)
		#tool.on_need_info.connect(_rebuild_info_panel)
		
		var btn := TextureButton.new()
		btn.ignore_texture_size = true
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		btn.custom_minimum_size = tool_icon_size
		btn.toggle_mode = true
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tool_map[btn] = tool
		btn.tooltip_text = tool.tool_hint
		btn.texture_normal = tool.tool_icon
		tools_grid.add_child(btn)
