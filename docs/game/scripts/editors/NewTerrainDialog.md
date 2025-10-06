# NewTerrainDialog Class Reference

*File:* `scripts/editors/TerrainSettingsDialog.gd`
*Class name:* `NewTerrainDialog`
*Inherits:* `Window`

## Synopsis

```gdscript
class_name NewTerrainDialog
extends Window
```

## Brief

Open the dialog for creating a new terrain (optionally pass defaults).

## Public Member Functions

- [`func _ready()`](NewTerrainDialog/functions/_ready.md)
- [`func open_for_edit(data: TerrainData) -> void`](NewTerrainDialog/functions/open_for_edit.md) — Open the dialog for editing an existing TerrainData
- [`func _on_primary_pressed()`](NewTerrainDialog/functions/_on_primary_pressed.md)
- [`func _fill_fields_from_data(data: TerrainData) -> void`](NewTerrainDialog/functions/_fill_fields_from_data.md)
- [`func _window_title_and_cta() -> void`](NewTerrainDialog/functions/_window_title_and_cta.md)
- [`func _reset_values()`](NewTerrainDialog/functions/_reset_values.md) — Reset values before popup (only when hiding)
- [`func show_dialog(state: bool)`](NewTerrainDialog/functions/show_dialog.md) — Show/hide dialog

## Public Attributes

- `TerrainEditor editor`
- `TerrainData _target_data`
- `LineEdit terrain_title`
- `SpinBox terrain_size_x`
- `SpinBox terrain_size_y`
- `SpinBox terrain_grid_x`
- `SpinBox terrain_grid_y`
- `SpinBox base_elevation`
- `Button create_btn`
- `Button cancel_btn`

## Signals

- `signal request_create(terrain_data)` — Request terrain create
- `signal request_edit(terrain_data)` — Request terrain edit

## Member Function Documentation

### _ready

```gdscript
func _ready()
```

### open_for_edit

```gdscript
func open_for_edit(data: TerrainData) -> void
```

Open the dialog for editing an existing TerrainData

### _on_primary_pressed

```gdscript
func _on_primary_pressed()
```

### _fill_fields_from_data

```gdscript
func _fill_fields_from_data(data: TerrainData) -> void
```

### _window_title_and_cta

```gdscript
func _window_title_and_cta() -> void
```

### _reset_values

```gdscript
func _reset_values()
```

Reset values before popup (only when hiding)

### show_dialog

```gdscript
func show_dialog(state: bool)
```

Show/hide dialog

## Member Data Documentation

### editor

```gdscript
var editor: TerrainEditor
```

### _target_data

```gdscript
var _target_data: TerrainData
```

### terrain_title

```gdscript
var terrain_title: LineEdit
```

### terrain_size_x

```gdscript
var terrain_size_x: SpinBox
```

### terrain_size_y

```gdscript
var terrain_size_y: SpinBox
```

### terrain_grid_x

```gdscript
var terrain_grid_x: SpinBox
```

### terrain_grid_y

```gdscript
var terrain_grid_y: SpinBox
```

### base_elevation

```gdscript
var base_elevation: SpinBox
```

### create_btn

```gdscript
var create_btn: Button
```

### cancel_btn

```gdscript
var cancel_btn: Button
```

## Signal Documentation

### request_create

```gdscript
signal request_create(terrain_data)
```

Request terrain create

### request_edit

```gdscript
signal request_edit(terrain_data)
```

Request terrain edit
