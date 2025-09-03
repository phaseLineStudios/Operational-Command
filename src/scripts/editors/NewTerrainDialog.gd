extends Window
class_name NewTerrainDialog

@onready var terrain_title: LineEdit = %NewTerrainTitle
@onready var terrain_size_x: SpinBox = %Size/X
@onready var terrain_size_y: SpinBox = %Size/Y
@onready var terrain_grid_x: SpinBox = %GridStart/X
@onready var terrain_grid_y: SpinBox = %GridStart/Y
@onready var create_btn: Button = %Create
@onready var cancel_btn: Button = %Cancel

signal request_create(terrain_data)

func _ready():
	create_btn.pressed.connect(_on_create_pressed)
	cancel_btn.pressed.connect(func (): show_dialog(false))
	close_requested.connect(func (): show_dialog(false))

func _on_create_pressed():
	var data = TerrainData.new()
	data.name = terrain_title.text
	data.width_m = terrain_size_x.value
	data.height_m = terrain_size_y.value
	data.grid_start_x = terrain_grid_x.value
	data.grid_start_y = terrain_grid_y.value
	
	show_dialog(false)
	emit_signal("request_create", data)

## Reset values before popup
func _reset_values():
	print("reset values")
	terrain_title.text = ""
	terrain_size_x.value = 2000
	terrain_size_y.value = 2000
	terrain_grid_x.value = 100
	terrain_grid_y.value = 100

## API to show/hide dialog window
func show_dialog(state: bool):
	visible = state
	if not state:
		_reset_values()
