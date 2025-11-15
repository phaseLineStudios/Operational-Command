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
- [`func _load_units_pool() -> void`](NewScenarioDialog/functions/_load_units_pool.md) — Load all units from ContentDB and build id map.
- [`func _refresh_unit_lists() -> void`](NewScenarioDialog/functions/_refresh_unit_lists.md) — Refresh both ItemLists from state.
- [`func _unit_line(u: UnitData) -> String`](NewScenarioDialog/functions/_unit_line.md) — Compose a display line.
- [`func _on_unit_add_pressed() -> void`](NewScenarioDialog/functions/_on_unit_add_pressed.md) — Add by ItemList selection (pool -> selected).
- [`func _on_unit_remove_pressed() -> void`](NewScenarioDialog/functions/_on_unit_remove_pressed.md) — Remove by ItemList selection (selected -> pool).
- [`func _on_unit_dropped(from_kind: int, to_kind: int, unit_id: String) -> void`](NewScenarioDialog/functions/_on_unit_dropped.md) — Drag & drop callback from UnitDDItemList.
- [`func _add_units_by_ids(ids: Array[String]) -> void`](NewScenarioDialog/functions/_add_units_by_ids.md) — Append units by ids (dedup).
- [`func _remove_units_by_ids(ids: Array[String]) -> void`](NewScenarioDialog/functions/_remove_units_by_ids.md) — Remove units by ids.

## Public Attributes

- `TerrainData terrain`
- `Texture2D thumbnail`
- `DialogMode dialog_mode`
- `ScenarioData working`
- `Array[UnitData] _all_units`
- `Dictionary _unit_by_id`
- `Array[UnitData] _selected_units`
- `LineEdit id_input`
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
- `ItemList unit_pool`
- `ItemList unit_selected`
- `Button unit_add`
- `Button unit_remove`

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

### _load_units_pool

```gdscript
func _load_units_pool() -> void
```

Load all units from ContentDB and build id map.

### _refresh_unit_lists

```gdscript
func _refresh_unit_lists() -> void
```

Refresh both ItemLists from state.

### _unit_line

```gdscript
func _unit_line(u: UnitData) -> String
```

Compose a display line.

### _on_unit_add_pressed

```gdscript
func _on_unit_add_pressed() -> void
```

Add by ItemList selection (pool -> selected).

### _on_unit_remove_pressed

```gdscript
func _on_unit_remove_pressed() -> void
```

Remove by ItemList selection (selected -> pool).

### _on_unit_dropped

```gdscript
func _on_unit_dropped(from_kind: int, to_kind: int, unit_id: String) -> void
```

Drag & drop callback from UnitDDItemList.
`from_kind` UnitDDItemList.Kind
`to_kind` UnitDDItemList.Kind

### _add_units_by_ids

```gdscript
func _add_units_by_ids(ids: Array[String]) -> void
```

Append units by ids (dedup).

### _remove_units_by_ids

```gdscript
func _remove_units_by_ids(ids: Array[String]) -> void
```

Remove units by ids.

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

### _all_units

```gdscript
var _all_units: Array[UnitData]
```

### _unit_by_id

```gdscript
var _unit_by_id: Dictionary
```

### _selected_units

```gdscript
var _selected_units: Array[UnitData]
```

### id_input

```gdscript
var id_input: LineEdit
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

### unit_pool

```gdscript
var unit_pool: ItemList
```

### unit_selected

```gdscript
var unit_selected: ItemList
```

### unit_add

```gdscript
var unit_add: Button
```

### unit_remove

```gdscript
var unit_remove: Button
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
