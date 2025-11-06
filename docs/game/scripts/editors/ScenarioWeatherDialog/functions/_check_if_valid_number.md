# ScenarioWeatherDialog::_check_if_valid_number Function Reference

*Defined at:* `scripts/editors/WeatherDialog.gd` (lines 183–189)</br>
*Belongs to:* [ScenarioWeatherDialog](../../ScenarioWeatherDialog.md)

**Signature**

```gdscript
func _check_if_valid_number(input: String) -> bool
```

## Description

Check if string is a valid number

## Source

```gdscript
func _check_if_valid_number(input: String) -> bool:
	if _regex.search(input):
		return true
	else:
		return false
```
