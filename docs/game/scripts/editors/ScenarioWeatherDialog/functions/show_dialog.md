# ScenarioWeatherDialog::show_dialog Function Reference

*Defined at:* `scripts/editors/WeatherDialog.gd` (lines 202–210)</br>
*Belongs to:* [ScenarioWeatherDialog](../../ScenarioWeatherDialog.md)

**Signature**

```gdscript
func show_dialog(state: bool)
```

## Description

Show/hide dialog

## Source

```gdscript
func show_dialog(state: bool):
	if state:
		_reset_values()
		popup_centered()
	else:
		if not editor.ctx.data:
			LogService.warning("Must create a scenario first", "WeatherDialog.gd:35")
			return
		hide()
```
