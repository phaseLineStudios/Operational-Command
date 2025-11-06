# ScenarioWeatherDialog::_on_time_slider_changed Function Reference

*Defined at:* `scripts/editors/WeatherDialog.gd` (lines 173–181)</br>
*Belongs to:* [ScenarioWeatherDialog](../../ScenarioWeatherDialog.md)

**Signature**

```gdscript
func _on_time_slider_changed(val: float) -> void
```

## Description

update time values from slider

## Source

```gdscript
func _on_time_slider_changed(val: float) -> void:
	_second = int(val) % 60
	_minute = int(val / 60.0) % 60
	_hour = int(val / 60.0 / 60.0) % 60
	time_hour.text = "%02d" % _hour
	time_minute.text = "%02d" % _minute
	time_second.text = "%02d" % _second
```
