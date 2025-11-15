# ScenarioWeatherDialog Class Reference

*File:* `scripts/editors/WeatherDialog.gd`
*Class name:* `ScenarioWeatherDialog`
*Inherits:* `Window`

## Synopsis

```gdscript
class_name ScenarioWeatherDialog
extends Window
```

## Public Member Functions

- [`func _ready()`](ScenarioWeatherDialog/functions/_ready.md)
- [`func _on_primary_pressed()`](ScenarioWeatherDialog/functions/_on_primary_pressed.md)
- [`func _reset_values()`](ScenarioWeatherDialog/functions/_reset_values.md) — Reset values before popup
- [`func _on_rain_spinbox_changed(val: float) -> void`](ScenarioWeatherDialog/functions/_on_rain_spinbox_changed.md) — Update rain slider
- [`func _on_rain_slider_changed(val: float) -> void`](ScenarioWeatherDialog/functions/_on_rain_slider_changed.md) — Update rain spinbox
- [`func _on_fog_spinbox_changed(val: float) -> void`](ScenarioWeatherDialog/functions/_on_fog_spinbox_changed.md) — Update fog slider
- [`func _on_fog_slider_changed(val: float) -> void`](ScenarioWeatherDialog/functions/_on_fog_slider_changed.md) — Update fog spinbox
- [`func _on_month_changed(idx: int) -> void`](ScenarioWeatherDialog/functions/_on_month_changed.md) — When month changes update day range.
- [`func _on_hour_changed(text: String) -> void`](ScenarioWeatherDialog/functions/_on_hour_changed.md) — Check if is number and update
- [`func _on_minute_changed(text: String) -> void`](ScenarioWeatherDialog/functions/_on_minute_changed.md) — Check if is number and update
- [`func _on_second_changed(text: String) -> void`](ScenarioWeatherDialog/functions/_on_second_changed.md) — Check if is number and update
- [`func _on_time_slider_changed(val: float) -> void`](ScenarioWeatherDialog/functions/_on_time_slider_changed.md) — update time values from slider
- [`func _check_if_valid_number(input: String) -> bool`](ScenarioWeatherDialog/functions/_check_if_valid_number.md) — Check if string is a valid number
- [`func _set_time(hour: int, minute: int, second: int) -> void`](ScenarioWeatherDialog/functions/_set_time.md) — Set time
- [`func show_dialog(state: bool)`](ScenarioWeatherDialog/functions/show_dialog.md) — Show/hide dialog

## Public Attributes

- `ScenarioEditor editor`
- `OptionButton date_year`
- `OptionButton date_month`
- `OptionButton date_day`
- `HSlider time_slider`
- `LineEdit time_hour`
- `LineEdit time_minute`
- `LineEdit time_second`
- `HSlider rain_slider`
- `SpinBox rain`
- `HSlider fog_slider`
- `SpinBox fog`
- `SpinBox wind_dir`
- `SpinBox wind_spd`
- `Button close_btn`
- `Button save_btn`

## Member Function Documentation

### _ready

```gdscript
func _ready()
```

### _on_primary_pressed

```gdscript
func _on_primary_pressed()
```

### _reset_values

```gdscript
func _reset_values()
```

Reset values before popup

### _on_rain_spinbox_changed

```gdscript
func _on_rain_spinbox_changed(val: float) -> void
```

Update rain slider

### _on_rain_slider_changed

```gdscript
func _on_rain_slider_changed(val: float) -> void
```

Update rain spinbox

### _on_fog_spinbox_changed

```gdscript
func _on_fog_spinbox_changed(val: float) -> void
```

Update fog slider

### _on_fog_slider_changed

```gdscript
func _on_fog_slider_changed(val: float) -> void
```

Update fog spinbox

### _on_month_changed

```gdscript
func _on_month_changed(idx: int) -> void
```

When month changes update day range.

### _on_hour_changed

```gdscript
func _on_hour_changed(text: String) -> void
```

Check if is number and update

### _on_minute_changed

```gdscript
func _on_minute_changed(text: String) -> void
```

Check if is number and update

### _on_second_changed

```gdscript
func _on_second_changed(text: String) -> void
```

Check if is number and update

### _on_time_slider_changed

```gdscript
func _on_time_slider_changed(val: float) -> void
```

update time values from slider

### _check_if_valid_number

```gdscript
func _check_if_valid_number(input: String) -> bool
```

Check if string is a valid number

### _set_time

```gdscript
func _set_time(hour: int, minute: int, second: int) -> void
```

Set time

### show_dialog

```gdscript
func show_dialog(state: bool)
```

Show/hide dialog

## Member Data Documentation

### editor

```gdscript
var editor: ScenarioEditor
```

### date_year

```gdscript
var date_year: OptionButton
```

### date_month

```gdscript
var date_month: OptionButton
```

### date_day

```gdscript
var date_day: OptionButton
```

### time_slider

```gdscript
var time_slider: HSlider
```

### time_hour

```gdscript
var time_hour: LineEdit
```

### time_minute

```gdscript
var time_minute: LineEdit
```

### time_second

```gdscript
var time_second: LineEdit
```

### rain_slider

```gdscript
var rain_slider: HSlider
```

### rain

```gdscript
var rain: SpinBox
```

### fog_slider

```gdscript
var fog_slider: HSlider
```

### fog

```gdscript
var fog: SpinBox
```

### wind_dir

```gdscript
var wind_dir: SpinBox
```

### wind_spd

```gdscript
var wind_spd: SpinBox
```

### close_btn

```gdscript
var close_btn: Button
```

### save_btn

```gdscript
var save_btn: Button
```
