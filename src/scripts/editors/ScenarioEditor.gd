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
@onready var terrain_overlay: Control = %Overlay
@onready var mouse_position_label: Label = %MousePosition

const MAIN_MENU_SCENE := "res://scenes/main_menu.tscn"

func _ready():
	file_menu.get_popup().connect("id_pressed", _on_filemenu_pressed)
	attribute_menu.get_popup().connect("id_pressed", _on_attributemenu_pressed)
	new_scenario_dialog.request_create.connect(_on_new_scenario)
	new_scenario_dialog.request_update.connect(_on_update_scenario)
	terrain_overlay.gui_input.connect(_on_overlay_gui_input)
	weather_dialog.editor = self

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

## Input handler for terrainview Viewport
func _on_overlay_gui_input(event):
	if event is InputEventMouseMotion:
		print("mouse")
		if data.terrain:
			print("terrain")
			var mp = terrain_render.map_to_terrain(event.position)
			var grid := terrain_render.pos_to_grid(mp)
			mouse_position_label.text = "(%d, %d | %s)" % [mp.x, mp.y, grid]
