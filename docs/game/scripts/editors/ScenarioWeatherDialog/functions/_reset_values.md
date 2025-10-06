# ScenarioWeatherDialog::_reset_values Function Reference

*Defined at:* `scripts/editors/WeatherDialog.gd` (lines 29–35)</br>
*Belongs to:* [ScenarioWeatherDialog](../ScenarioWeatherDialog.md)

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
```
