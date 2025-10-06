# NewScenarioDialog Class Reference

*File:* `scripts/editors/NewScenarioDialog.gd`
*Class name:* `NewScenarioDialog`
*Inherits:* `Window`

## Synopsis

```gdscript
class_name NewScenarioDialog
extends Window
```

## Public Member Functions

- [`func _ready()`](NewScenarioDialog/functions/_ready.md)
- [`func _on_primary_pressed() -> void`](NewScenarioDialog/functions/_on_primary_pressed.md)
- [`func _on_terrain_select() -> void`](NewScenarioDialog/functions/_on_terrain_select.md)
- [`func _on_thumbnail_select() -> void`](NewScenarioDialog/functions/_on_thumbnail_select.md)
- [`func _on_thumbnail_clear() -> void`](NewScenarioDialog/functions/_on_thumbnail_clear.md)
- [`func _reset_values() -> void`](NewScenarioDialog/functions/_reset_values.md) — Reset values before popup (only when hiding)
- [`func _load_from_data(d: ScenarioData) -> void`](NewScenarioDialog/functions/_load_from_data.md) — Preload fields from existing ScenarioData.
- [`func _title_button_from_mode() -> void`](NewScenarioDialog/functions/_title_button_from_mode.md) — Update window title and primary button text to reflect mode.
- [`func show_dialog(state: bool, existing: ScenarioData = null) -> void`](NewScenarioDialog/functions/show_dialog.md) — Show/hide dialog.

## Public Attributes

- `TerrainData terrain`
- `Texture2D thumbnail`
- `DialogMode dialog_mode`
- `ScenarioData working`
- `LineEdit title_input`
- `TextEdit desc_input`
- `TextureRect thumb_preview`
- `LineEdit thumb_path`
- `Button thumb_btn`
- `Button thumb_clear`
- `LineEdit terrain_path`
- `Button terrain_btn`
- `Button close_btn`
- `Button create_btn`

## Signals

- `signal request_create(scenario_data: ScenarioData)` — Emitted when user confirms new.
- `signal request_update(scenario_data: ScenarioData)` — Emitted when user confirms edit.

## Enumerations

- `enum DialogMode`

## Member Function Documentation

### _ready

```gdscript
func _ready()
```

### _on_primary_pressed

```gdscript
func _on_primary_pressed() -> void
```

### _on_terrain_select

```gdscript
func _on_terrain_select() -> void
```

### _on_thumbnail_select

```gdscript
func _on_thumbnail_select() -> void
```

### _on_thumbnail_clear

```gdscript
func _on_thumbnail_clear() -> void
```

### _reset_values

```gdscript
func _reset_values() -> void
```

Reset values before popup (only when hiding)

### _load_from_data

```gdscript
func _load_from_data(d: ScenarioData) -> void
```

Preload fields from existing ScenarioData.

### _title_button_from_mode

```gdscript
func _title_button_from_mode() -> void
```

Update window title and primary button text to reflect mode.

### show_dialog

```gdscript
func show_dialog(state: bool, existing: ScenarioData = null) -> void
```

Show/hide dialog.

## Member Data Documentation

### terrain

```gdscript
var terrain: TerrainData
```

### thumbnail

```gdscript
var thumbnail: Texture2D
```

### dialog_mode

```gdscript
var dialog_mode: DialogMode
```

### working

```gdscript
var working: ScenarioData
```

### title_input

```gdscript
var title_input: LineEdit
```

### desc_input

```gdscript
var desc_input: TextEdit
```

### thumb_preview

```gdscript
var thumb_preview: TextureRect
```

### thumb_path

```gdscript
var thumb_path: LineEdit
```

### thumb_btn

```gdscript
var thumb_btn: Button
```

### thumb_clear

```gdscript
var thumb_clear: Button
```

### terrain_path

```gdscript
var terrain_path: LineEdit
```

### terrain_btn

```gdscript
var terrain_btn: Button
```

### close_btn

```gdscript
var close_btn: Button
```

### create_btn

```gdscript
var create_btn: Button
```

## Signal Documentation

### request_create

```gdscript
signal request_create(scenario_data: ScenarioData)
```

Emitted when user confirms new.

### request_update

```gdscript
signal request_update(scenario_data: ScenarioData)
```

Emitted when user confirms edit.

## Enumeration Type Documentation

### DialogMode

```gdscript
enum DialogMode
```
