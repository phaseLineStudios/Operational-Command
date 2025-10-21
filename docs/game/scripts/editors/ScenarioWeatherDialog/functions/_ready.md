# ScenarioWeatherDialog::_ready Function Reference

*Defined at:* `scripts/editors/WeatherDialog.gd` (lines 14–19)</br>
*Belongs to:* [ScenarioWeatherDialog](../../ScenarioWeatherDialog.md)

**Signature**

```gdscript
func _ready()
```

## Source

```gdscript
func _ready():
	save_btn.pressed.connect(_on_primary_pressed)
	close_btn.pressed.connect(func(): show_dialog(false))
	close_requested.connect(func(): show_dialog(false))
```
