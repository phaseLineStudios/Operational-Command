# ScenarioWeatherDialog::_on_hour_changed Function Reference

*Defined at:* `scripts/editors/WeatherDialog.gd` (lines 146–153)</br>
*Belongs to:* [ScenarioWeatherDialog](../../ScenarioWeatherDialog.md)

**Signature**

```gdscript
func _on_hour_changed(text: String) -> void
```

## Description

Check if is number and update

## Source

```gdscript
func _on_hour_changed(text: String) -> void:
	if _check_if_valid_number(text):
		_hour = int(text)
	else:
		time_hour.text = "%02d" % _hour
	time_slider.value = _second + _minute * 60 + _hour * 60 * 60
```
