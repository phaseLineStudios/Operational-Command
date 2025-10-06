# ScenarioWeatherDialog::show_dialog Function Reference

*Defined at:* `scripts/editors/WeatherDialog.gd` (lines 37–45)</br>
*Belongs to:* [ScenarioWeatherDialog](../ScenarioWeatherDialog.md)

**Signature**

```gdscript
func show_dialog(state: bool)
```

## Description

Show/hide dialog

## Source

```gdscript
func show_dialog(state: bool):
	if not editor.ctx.data:
		LogService.warning("Must create a scenario first", "WeatherDialog.gd:35")
		return

	if state:
		_reset_values()

	visible = state
```
