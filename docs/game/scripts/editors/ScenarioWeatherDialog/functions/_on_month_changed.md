# ScenarioWeatherDialog::_on_month_changed Function Reference

*Defined at:* `scripts/editors/WeatherDialog.gd` (lines 131–144)</br>
*Belongs to:* [ScenarioWeatherDialog](../../ScenarioWeatherDialog.md)

**Signature**

```gdscript
func _on_month_changed(idx: int) -> void
```

## Description

When month changes update day range.

## Source

```gdscript
func _on_month_changed(idx: int) -> void:
	date_day.clear()
	var day_range: Array
	if idx % 2 == 0:
		if idx == 1:
			day_range = range(1, 29)
		else:
			day_range = range(1, 31)
	else:
		day_range = range(1, 32)
	for day in day_range:
		date_day.add_item(str(day), day)
```
