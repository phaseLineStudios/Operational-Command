# ScenarioWeatherDialog::_ready Function Reference

*Defined at:* `scripts/editors/WeatherDialog.gd` (lines 50–82)</br>
*Belongs to:* [ScenarioWeatherDialog](../../ScenarioWeatherDialog.md)

**Signature**

```gdscript
func _ready()
```

## Source

```gdscript
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
```
