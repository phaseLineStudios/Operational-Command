# ScenarioWeatherDialog::_reset_values Function Reference

*Defined at:* `scripts/editors/WeatherDialog.gd` (lines 98–109)</br>
*Belongs to:* [ScenarioWeatherDialog](../../ScenarioWeatherDialog.md)

**Signature**

```gdscript
func _reset_values()
```

## Description

Reset values before popup

## Source

```gdscript
func _reset_values():
	rain.value = editor.ctx.data.rain
	fog.value = editor.ctx.data.fog_m
	wind_dir.value = editor.ctx.data.wind_dir
	wind_spd.value = editor.ctx.data.wind_speed_m

	date_year.selected = editor.ctx.data.year - YEAR_START
	date_month.selected = editor.ctx.data.month - 1
	date_day.selected = editor.ctx.data.day - 1
	_set_time(editor.ctx.data.hour, editor.ctx.data.minute, editor.ctx.data.second)
```
