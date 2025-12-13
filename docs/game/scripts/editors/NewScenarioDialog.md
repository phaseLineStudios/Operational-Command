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
- [`func _on_video_select() -> void`](NewScenarioDialog/functions/_on_video_select.md)
- [`func _on_video_clear() -> void`](NewScenarioDialog/functions/_on_video_clear.md)
- [`func _on_subtitles_select() -> void`](NewScenarioDialog/functions/_on_subtitles_select.md)
- [`func _on_subtitles_clear() -> void`](NewScenarioDialog/functions/_on_subtitles_clear.md)
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
- [`func _apply_pools_to_scenario(sd: ScenarioData) -> void`](NewScenarioDialog/functions/_apply_pools_to_scenario.md) — Apply pool values from UI to ScenarioData.
- [`func _load_pools_from_scenario(d: ScenarioData) -> void`](NewScenarioDialog/functions/_load_pools_from_scenario.md) — Load pool values from ScenarioData to UI.
- [`func _reset_pool_values() -> void`](NewScenarioDialog/functions/_reset_pool_values.md) — Reset pool values to defaults.

## Public Attributes

- `TerrainData terrain`
- `Texture2D thumbnail`
- `VideoStream video_stream`
- `SubtitleTrack subtitle_track`
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
- `LineEdit video_path`
- `Button video_btn`
- `Button video_clear`
- `LineEdit subtitles_path`
- `Button subtitles_btn`
- `Button subtitles_clear`
- `Button close_btn`
- `Button create_btn`
- `ItemList unit_pool`
- `ItemList unit_selected`
- `Button unit_add`
- `Button unit_remove`
- `SpinBox replacement_pool_spin`
- `SpinBox equipment_pool_spin`
- `SpinBox small_arms_spin`
- `SpinBox tank_gun_spin`
- `SpinBox atgm_spin`
- `SpinBox at_rocket_spin`
- `SpinBox heavy_weapons_spin`
- `SpinBox autocannon_spin`
- `SpinBox mortar_ap_spin`
- `SpinBox mortar_smoke_spin`
- `SpinBox mortar_illum_spin`
- `SpinBox artillery_ap_spin`
- `SpinBox artillery_smoke_spin`
- `SpinBox artillery_illum_spin`
- `SpinBox engineer_mun_spin`

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

### _on_video_select

```gdscript
func _on_video_select() -> void
```

### _on_video_clear

```gdscript
func _on_video_clear() -> void
```

### _on_subtitles_select

```gdscript
func _on_subtitles_select() -> void
```

### _on_subtitles_clear

```gdscript
func _on_subtitles_clear() -> void
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

### _apply_pools_to_scenario

```gdscript
func _apply_pools_to_scenario(sd: ScenarioData) -> void
```

Apply pool values from UI to ScenarioData.

### _load_pools_from_scenario

```gdscript
func _load_pools_from_scenario(d: ScenarioData) -> void
```

Load pool values from ScenarioData to UI.

### _reset_pool_values

```gdscript
func _reset_pool_values() -> void
```

Reset pool values to defaults.

## Member Data Documentation

### terrain

```gdscript
var terrain: TerrainData
```

### thumbnail

```gdscript
var thumbnail: Texture2D
```

### video_stream

```gdscript
var video_stream: VideoStream
```

### subtitle_track

```gdscript
var subtitle_track: SubtitleTrack
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

### video_path

```gdscript
var video_path: LineEdit
```

### video_btn

```gdscript
var video_btn: Button
```

### video_clear

```gdscript
var video_clear: Button
```

### subtitles_path

```gdscript
var subtitles_path: LineEdit
```

### subtitles_btn

```gdscript
var subtitles_btn: Button
```

### subtitles_clear

```gdscript
var subtitles_clear: Button
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

### replacement_pool_spin

```gdscript
var replacement_pool_spin: SpinBox
```

### equipment_pool_spin

```gdscript
var equipment_pool_spin: SpinBox
```

### small_arms_spin

```gdscript
var small_arms_spin: SpinBox
```

### tank_gun_spin

```gdscript
var tank_gun_spin: SpinBox
```

### atgm_spin

```gdscript
var atgm_spin: SpinBox
```

### at_rocket_spin

```gdscript
var at_rocket_spin: SpinBox
```

### heavy_weapons_spin

```gdscript
var heavy_weapons_spin: SpinBox
```

### autocannon_spin

```gdscript
var autocannon_spin: SpinBox
```

### mortar_ap_spin

```gdscript
var mortar_ap_spin: SpinBox
```

### mortar_smoke_spin

```gdscript
var mortar_smoke_spin: SpinBox
```

### mortar_illum_spin

```gdscript
var mortar_illum_spin: SpinBox
```

### artillery_ap_spin

```gdscript
var artillery_ap_spin: SpinBox
```

### artillery_smoke_spin

```gdscript
var artillery_smoke_spin: SpinBox
```

### artillery_illum_spin

```gdscript
var artillery_illum_spin: SpinBox
```

### engineer_mun_spin

```gdscript
var engineer_mun_spin: SpinBox
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
