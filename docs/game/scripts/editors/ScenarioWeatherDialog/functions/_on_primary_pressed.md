# ScenarioWeatherDialog::_on_primary_pressed Function Reference

*Defined at:* `scripts/editors/WeatherDialog.gd` (lines 20–27)</br>
*Belongs to:* [ScenarioWeatherDialog](../../ScenarioWeatherDialog.md)

**Signature**

```gdscript
func _on_primary_pressed()
```

## Source

```gdscript
func _on_primary_pressed():
	editor.ctx.data.rain = rain.value
	editor.ctx.data.fog_m = fog.value
	editor.ctx.data.wind_dir = wind_dir.value
	editor.ctx.data.wind_speed_m = wind_spd.value
	show_dialog(false)
```
