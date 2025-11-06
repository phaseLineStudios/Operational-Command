# ScenarioWeatherDialog::_on_second_changed Function Reference

*Defined at:* `scripts/editors/WeatherDialog.gd` (lines 164–171)</br>
*Belongs to:* [ScenarioWeatherDialog](../../ScenarioWeatherDialog.md)

**Signature**

```gdscript
func _on_second_changed(text: String) -> void
```

## Description

Check if is number and update

## Source

```gdscript
func _on_second_changed(text: String) -> void:
	if _check_if_valid_number(text):
		_second = int(text)
	else:
		time_second.text = "%02d" % _hour
	time_slider.value = _second + _minute * 60 + _hour * 60 * 60
```
