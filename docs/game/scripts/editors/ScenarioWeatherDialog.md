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
- [`func show_dialog(state: bool)`](ScenarioWeatherDialog/functions/show_dialog.md) — Show/hide dialog

## Public Attributes

- `ScenarioEditor editor`
- `SpinBox rain`
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

### rain

```gdscript
var rain: SpinBox
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
