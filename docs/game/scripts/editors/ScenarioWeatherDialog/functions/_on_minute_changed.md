# ScenarioWeatherDialog::_on_minute_changed Function Reference

*Defined at:* `scripts/editors/WeatherDialog.gd` (lines 155–162)</br>
*Belongs to:* [ScenarioWeatherDialog](../../ScenarioWeatherDialog.md)

**Signature**

```gdscript
func _on_minute_changed(text: String) -> void
```

## Description

Check if is number and update

## Source

```gdscript
func _on_minute_changed(text: String) -> void:
	if _check_if_valid_number(text):
		_minute = int(text)
	else:
		time_minute.text = "%02d" % _hour
	time_slider.value = _second + _minute * 60 + _hour * 60 * 60
```
