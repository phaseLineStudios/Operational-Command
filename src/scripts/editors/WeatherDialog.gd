class_name ScenarioWeatherDialog
extends Window

var editor: ScenarioEditor

@onready var rain: SpinBox = %Rain
@onready var fog: SpinBox = %Fog
@onready var wind_dir: SpinBox = %WindDir
@onready var wind_spd: SpinBox = %WindSpeed
@onready var close_btn: Button = %Close
@onready var save_btn: Button = %Save


func _ready():
	save_btn.pressed.connect(_on_primary_pressed)
	close_btn.pressed.connect(func(): show_dialog(false))
	close_requested.connect(func(): show_dialog(false))


func _on_primary_pressed():
	editor.ctx.data.rain = rain.value
	editor.ctx.data.fog_m = fog.value
	editor.ctx.data.wind_dir = wind_dir.value
	editor.ctx.data.wind_speed_m = wind_spd.value
	show_dialog(false)


## Reset values before popup
func _reset_values():
	rain.value = editor.ctx.data.rain
	fog.value = editor.ctx.data.fog_m
	wind_dir.value = editor.ctx.data.wind_dir
	wind_spd.value = editor.ctx.data.wind_speed_m


## Show/hide dialog
func show_dialog(state: bool):
	if not editor.ctx.data:
		LogService.warning("Must create a scenario first", "WeatherDialog.gd:35")
		return

	if state:
		_reset_values()

	visible = state
