extends Window
class_name NewTerrainDialog

@onready var terrain_title = %NewTerrainTitle
@onready var terrain_size_x = %Size/X
@onready var terrain_size_y = %Size/Y
@onready var terrain_grid_x = %GridStart/X
@onready var terrain_grid_y = %GridStart/Y
@onready var create_btn = %Create

signal request_create(terrain_data)

func _ready():
	create_btn.pressed.connect(_on_create_pressed)

func _on_create_pressed():
	var data = TerrainData.new()
	data.name = terrain_title.text
	data.width_m = terrain_size_x.value
	data.height_m = terrain_size_y.value
	data.grid_start_x = terrain_grid_x.value
	data.grid_start_y = terrain_grid_y.value
	
	show_dialog(false)
	emit_signal("request_create", data)

func show_dialog(state: bool):
	visible = state
