# ScenarioWeatherDialog::_set_time Function Reference

*Defined at:* `scripts/editors/WeatherDialog.gd` (lines 191–200)</br>
*Belongs to:* [ScenarioWeatherDialog](../../ScenarioWeatherDialog.md)

**Signature**

```gdscript
func _set_time(hour: int, minute: int, second: int) -> void
```

## Description

Set time

## Source

```gdscript
func _set_time(hour: int, minute: int, second: int) -> void:
	_hour = hour
	time_hour.text = "%02d" % hour
	_minute = minute
	time_minute.text = "%02d" % minute
	_second = second
	time_second.text = "%02d" % second
	time_slider.value = _second + _minute * 60 + _hour * 60 * 60
```
