# ScenarioWeatherDialog::_on_primary_pressed Function Reference

*Defined at:* `scripts/editors/WeatherDialog.gd` (lines 83–96)</br>
*Belongs to:* [ScenarioWeatherDialog](../../ScenarioWeatherDialog.md)

**Signature**

```gdscript
func _on_primary_pressed()
```

## Source

```gdscript
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
```
