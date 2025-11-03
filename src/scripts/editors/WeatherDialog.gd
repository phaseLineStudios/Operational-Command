class_name ScenarioWeatherDialog
extends Window

enum Month {
	JANUARY = 1,
	FEBRUARY = 2,
	MARCH = 3,
	APRIL = 4,
	MAY = 5,
	JUNE = 6,
	JULY = 7,
	AUGUST = 8,
	SEPTEMBER = 9,
	OCTOBER = 10,
	NOVEMBER = 11,
	DECEMBER = 12
}

const YEAR_START := 1900

var editor: ScenarioEditor
var _regex := RegEx.new()

var _hour := 12
var _minute := 0
var _second := 0

@onready var date_year: OptionButton = %Year
@onready var date_month: OptionButton = %Month
@onready var date_day: OptionButton = %Day

@onready var time_slider: HSlider = %TimeSlider
@onready var time_hour: LineEdit = %Hour
@onready var time_minute: LineEdit = %Minute
@onready var time_second: LineEdit = %Second

@onready var rain_slider: HSlider = %RainSlider
@onready var rain: SpinBox = %Rain

@onready var fog_slider: HSlider = %FogSlider
@onready var fog: SpinBox = %Fog

@onready var wind_dir: SpinBox = %WindDir
@onready var wind_spd: SpinBox = %WindSpeed

@onready var close_btn: Button = %Close
@onready var save_btn: Button = %Save


func _ready():
	_regex.compile("^[0-9]*$")

	var real_date := Time.get_date_dict_from_system()

	for year in range(YEAR_START, real_date.year):
		date_year.add_item(str(year), year)
	for month in Month.keys():
		var month_str: String = month[0].to_upper() + month.substr(1, -1).to_lower()
		date_month.add_item(month_str, Month[month])
	for day in range(1, 31):
		date_day.add_item(str(day), day)

	date_year.select(1983 - YEAR_START)
	date_month.select(Month.NOVEMBER - 1)
	date_day.select(15 - 1)

	date_month.item_selected.connect(_on_month_changed)
	time_slider.value_changed.connect(_on_time_slider_changed)
	time_hour.text_changed.connect(_on_hour_changed)
	time_minute.text_changed.connect(_on_minute_changed)
	time_second.text_changed.connect(_on_second_changed)

	rain_slider.value_changed.connect(_on_rain_slider_changed)
	rain.value_changed.connect(_on_rain_spinbox_changed)
	fog_slider.value_changed.connect(_on_fog_slider_changed)
	fog.value_changed.connect(_on_fog_spinbox_changed)

	save_btn.pressed.connect(_on_primary_pressed)
	close_btn.pressed.connect(func(): show_dialog(false))
	close_requested.connect(func(): show_dialog(false))


func _on_primary_pressed():
	editor.ctx.data.year = YEAR_START + date_year.selected
	editor.ctx.data.month = date_month.selected + 1
	editor.ctx.data.day = date_day.selected + 1
	editor.ctx.data.hour = _hour
	editor.ctx.data.minute = _minute
	editor.ctx.data.second = _second
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

	date_year.selected = editor.ctx.data.year - YEAR_START
	date_month.selected = editor.ctx.data.month - 1
	date_day.selected = editor.ctx.data.day - 1
	_set_time(editor.ctx.data.hour, editor.ctx.data.minute, editor.ctx.data.second)


## Update rain slider
func _on_rain_spinbox_changed(val: float) -> void:
	rain_slider.value = val


## Update rain spinbox
func _on_rain_slider_changed(val: float) -> void:
	rain.value = val


## Update fog slider
func _on_fog_spinbox_changed(val: float) -> void:
	fog_slider.value = val


## Update fog spinbox
func _on_fog_slider_changed(val: float) -> void:
	fog.value = val


## When month changes update day range.
func _on_month_changed(idx: int) -> void:
	date_day.clear()
	var day_range: Array
	if idx % 2 == 0:
		if idx == 1:
			day_range = range(1, 29)
		else:
			day_range = range(1, 31)
	else:
		day_range = range(1, 32)
	for day in day_range:
		date_day.add_item(str(day), day)


## Check if is number and update
func _on_hour_changed(text: String) -> void:
	if _check_if_valid_number(text):
		_hour = int(text)
	else:
		time_hour.text = "%02d" % _hour
	time_slider.value = _second + _minute * 60 + _hour * 60 * 60


## Check if is number and update
func _on_minute_changed(text: String) -> void:
	if _check_if_valid_number(text):
		_minute = int(text)
	else:
		time_minute.text = "%02d" % _hour
	time_slider.value = _second + _minute * 60 + _hour * 60 * 60


## Check if is number and update
func _on_second_changed(text: String) -> void:
	if _check_if_valid_number(text):
		_second = int(text)
	else:
		time_second.text = "%02d" % _hour
	time_slider.value = _second + _minute * 60 + _hour * 60 * 60


## update time values from slider
func _on_time_slider_changed(val: float) -> void:
	_second = int(val) % 60
	_minute = int(val / 60.0) % 60
	_hour = int(val / 60.0 / 60.0) % 60
	time_hour.text = "%02d" % _hour
	time_minute.text = "%02d" % _minute
	time_second.text = "%02d" % _second


## Check if string is a valid number
func _check_if_valid_number(input: String) -> bool:
	if _regex.search(input):
		return true
	else:
		return false


## Set time
func _set_time(hour: int, minute: int, second: int) -> void:
	_hour = hour
	time_hour.text = "%02d" % hour
	_minute = minute
	time_minute.text = "%02d" % minute
	_second = second
	time_second.text = "%02d" % second
	time_slider.value = _second + _minute * 60 + _hour * 60 * 60


## Show/hide dialog
func show_dialog(state: bool):
	if state:
		_reset_values()
		popup_centered()
	else:
		if not editor.ctx.data:
			LogService.warning("Must create a scenario first", "WeatherDialog.gd:35")
			return
		hide()
