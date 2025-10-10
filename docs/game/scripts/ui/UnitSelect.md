# UnitSelect Class Reference

*File:* `scripts/ui/UnitSelect.gd`
*Class name:* `UnitSelect`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name UnitSelect
extends Control
```

## Brief

Unit selection controller.

## Detailed Description

Loads mission, builds pool and slots, handles drag/drop, points and logistics.

Path to briefing scene

Path to hq table scene

## Public Member Functions

- [`func _ready() -> void`](UnitSelect/functions/_ready.md) — Build UI, load mission
- [`func _connect_ui() -> void`](UnitSelect/functions/_connect_ui.md) — Connect UI actions to methods
- [`func _load_mission() -> void`](UnitSelect/functions/_load_mission.md) — Load mission data into the UI
- [`func _build_slots() -> void`](UnitSelect/functions/_build_slots.md) — Build slot list from mission slot definitions
- [`func _build_pool() -> void`](UnitSelect/functions/_build_pool.md) — Build the pool of recruitable unit cards
- [`func _on_filter_changed(button: Button) -> void`](UnitSelect/functions/_on_filter_changed.md) — Handle filter button toggled
- [`func _on_filter_text_changed(_t: String) -> void`](UnitSelect/functions/_on_filter_text_changed.md) — Handle text search filter changed
- [`func _active_roles() -> PackedStringArray`](UnitSelect/functions/_active_roles.md) — Collect roles enabled in current filter
- [`func _refresh_pool_filter() -> void`](UnitSelect/functions/_refresh_pool_filter.md) — Refresh pool visibility based on filter/search/assignment
- [`func _refresh_filters() -> void`](UnitSelect/functions/_refresh_filters.md) — Reset all role filter buttons
- [`func _on_request_assign_drop(slot_id: String, unit: UnitData, source_slot_id: String) -> void`](UnitSelect/functions/_on_request_assign_drop.md) — Called when a slot requests to assign a unit
- [`func _try_assign(slot_id: String, unit: UnitData) -> void`](UnitSelect/functions/_try_assign.md) — Attempt to assign a unit to a slot with validation
- [`func _on_request_return_to_pool(slot_id: String, _unit: UnitData) -> void`](UnitSelect/functions/_on_request_return_to_pool.md) — Called when a slot unit is returned to pool
- [`func _unassign_slot(slot_id: String) -> void`](UnitSelect/functions/_unassign_slot.md) — Unassign a unit from the given slot
- [`func _refresh_topbar() -> void`](UnitSelect/functions/_refresh_topbar.md) — Update topbar with used slots and points
- [`func _recompute_logistics() -> void`](UnitSelect/functions/_recompute_logistics.md) — Recalculate logistics totals from assigned units
- [`func _update_logistics_labels(equipment: int, fuel: int, medical: int, repair: int) -> void`](UnitSelect/functions/_update_logistics_labels.md) — Update logistics labels with current totals
- [`func _on_card_selected(unit: UnitData) -> void`](UnitSelect/functions/_on_card_selected.md) — Handle card clicked in pool
- [`func _update_card_selection(unit: UnitData) -> void`](UnitSelect/functions/_update_card_selection.md) — Highlight the selected card in the pool
- [`func _on_request_inspect_from_tree(unit: UnitData) -> void`](UnitSelect/functions/_on_request_inspect_from_tree.md) — Inspect unit from slot list and show stats
- [`func _show_unit_stats(unit: UnitData) -> void`](UnitSelect/functions/_show_unit_stats.md) — Update stats panel with selected unit data
- [`func _on_back_pressed() -> void`](UnitSelect/functions/_on_back_pressed.md) — Go back to briefing scene
- [`func _on_reset_pressed() -> void`](UnitSelect/functions/_on_reset_pressed.md) — Reset all slots to empty
- [`func _on_deploy_pressed() -> void`](UnitSelect/functions/_on_deploy_pressed.md) — Deploy current loadout if slots are filled
- [`func _update_deploy_enabled() -> void`](UnitSelect/functions/_update_deploy_enabled.md) — Enable/disable deploy button based on slot fill
- [`func _export_loadout() -> Dictionary`](UnitSelect/functions/_export_loadout.md) — Export current mission loadout as dictionary

## Public Attributes

- `Texture2D default_unit_icon` — Default fallback icon for units.
- `PackedScene unit_card_scene` — Scene used for unit cards
- `int _total_points`
- `int _total_slots`
- `Dictionary _cards_by_unit`
- `Dictionary _units_by_id`
- `Dictionary _slot_data`
- `Dictionary _assigned_by_unit`
- `int _used_points`
- `UnitCard _selected_card`
- `Label _lbl_title`
- `Label _lbl_points`
- `Label _lbl_slots`
- `Button _btn_back`
- `Button _btn_reset`
- `Button _btn_deploy`
- `Button _filter_all`
- `Button _filter_armor`
- `Button _filter_inf`
- `Button _filter_mech`
- `Button _filter_motor`
- `Button _filter_support`
- `LineEdit _search`
- `PoolDropArea _pool`
- `SlotsList _slots_list`
- `Label _lbl_ammo`
- `Label _lbl_fuel`
- `Label _lbl_med`
- `Label _lbl_rep`
- `Label _lbl_vet`
- `Label _lbl_att`
- `Label _lbl_def`
- `Label _lbl_spot`
- `Label _lbl_range`
- `Label _lbl_morale`
- `Label _lbl_speed`
- `Label _lbl_coh`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Build UI, load mission

### _connect_ui

```gdscript
func _connect_ui() -> void
```

Connect UI actions to methods

### _load_mission

```gdscript
func _load_mission() -> void
```

Load mission data into the UI

### _build_slots

```gdscript
func _build_slots() -> void
```

Build slot list from mission slot definitions

### _build_pool

```gdscript
func _build_pool() -> void
```

Build the pool of recruitable unit cards

### _on_filter_changed

```gdscript
func _on_filter_changed(button: Button) -> void
```

Handle filter button toggled

### _on_filter_text_changed

```gdscript
func _on_filter_text_changed(_t: String) -> void
```

Handle text search filter changed

### _active_roles

```gdscript
func _active_roles() -> PackedStringArray
```

Collect roles enabled in current filter

### _refresh_pool_filter

```gdscript
func _refresh_pool_filter() -> void
```

Refresh pool visibility based on filter/search/assignment

### _refresh_filters

```gdscript
func _refresh_filters() -> void
```

Reset all role filter buttons

### _on_request_assign_drop

```gdscript
func _on_request_assign_drop(slot_id: String, unit: UnitData, source_slot_id: String) -> void
```

Called when a slot requests to assign a unit

### _try_assign

```gdscript
func _try_assign(slot_id: String, unit: UnitData) -> void
```

Attempt to assign a unit to a slot with validation

### _on_request_return_to_pool

```gdscript
func _on_request_return_to_pool(slot_id: String, _unit: UnitData) -> void
```

Called when a slot unit is returned to pool

### _unassign_slot

```gdscript
func _unassign_slot(slot_id: String) -> void
```

Unassign a unit from the given slot

### _refresh_topbar

```gdscript
func _refresh_topbar() -> void
```

Update topbar with used slots and points

### _recompute_logistics

```gdscript
func _recompute_logistics() -> void
```

Recalculate logistics totals from assigned units

### _update_logistics_labels

```gdscript
func _update_logistics_labels(equipment: int, fuel: int, medical: int, repair: int) -> void
```

Update logistics labels with current totals

### _on_card_selected

```gdscript
func _on_card_selected(unit: UnitData) -> void
```

Handle card clicked in pool

### _update_card_selection

```gdscript
func _update_card_selection(unit: UnitData) -> void
```

Highlight the selected card in the pool

### _on_request_inspect_from_tree

```gdscript
func _on_request_inspect_from_tree(unit: UnitData) -> void
```

Inspect unit from slot list and show stats

### _show_unit_stats

```gdscript
func _show_unit_stats(unit: UnitData) -> void
```

Update stats panel with selected unit data

### _on_back_pressed

```gdscript
func _on_back_pressed() -> void
```

Go back to briefing scene

### _on_reset_pressed

```gdscript
func _on_reset_pressed() -> void
```

Reset all slots to empty

### _on_deploy_pressed

```gdscript
func _on_deploy_pressed() -> void
```

Deploy current loadout if slots are filled

### _update_deploy_enabled

```gdscript
func _update_deploy_enabled() -> void
```

Enable/disable deploy button based on slot fill

### _export_loadout

```gdscript
func _export_loadout() -> Dictionary
```

Export current mission loadout as dictionary

## Member Data Documentation

### default_unit_icon

```gdscript
var default_unit_icon: Texture2D
```

Decorators: `@export`

Default fallback icon for units.

### unit_card_scene

```gdscript
var unit_card_scene: PackedScene
```

Decorators: `@export`

Scene used for unit cards

### _total_points

```gdscript
var _total_points: int
```

### _total_slots

```gdscript
var _total_slots: int
```

### _cards_by_unit

```gdscript
var _cards_by_unit: Dictionary
```

### _units_by_id

```gdscript
var _units_by_id: Dictionary
```

### _slot_data

```gdscript
var _slot_data: Dictionary
```

### _assigned_by_unit

```gdscript
var _assigned_by_unit: Dictionary
```

### _used_points

```gdscript
var _used_points: int
```

### _selected_card

```gdscript
var _selected_card: UnitCard
```

### _lbl_title

```gdscript
var _lbl_title: Label
```

### _lbl_points

```gdscript
var _lbl_points: Label
```

### _lbl_slots

```gdscript
var _lbl_slots: Label
```

### _btn_back

```gdscript
var _btn_back: Button
```

### _btn_reset

```gdscript
var _btn_reset: Button
```

### _btn_deploy

```gdscript
var _btn_deploy: Button
```

### _filter_all

```gdscript
var _filter_all: Button
```

### _filter_armor

```gdscript
var _filter_armor: Button
```

### _filter_inf

```gdscript
var _filter_inf: Button
```

### _filter_mech

```gdscript
var _filter_mech: Button
```

### _filter_motor

```gdscript
var _filter_motor: Button
```

### _filter_support

```gdscript
var _filter_support: Button
```

### _search

```gdscript
var _search: LineEdit
```

### _pool

```gdscript
var _pool: PoolDropArea
```

### _slots_list

```gdscript
var _slots_list: SlotsList
```

### _lbl_ammo

```gdscript
var _lbl_ammo: Label
```

### _lbl_fuel

```gdscript
var _lbl_fuel: Label
```

### _lbl_med

```gdscript
var _lbl_med: Label
```

### _lbl_rep

```gdscript
var _lbl_rep: Label
```

### _lbl_vet

```gdscript
var _lbl_vet: Label
```

### _lbl_att

```gdscript
var _lbl_att: Label
```

### _lbl_def

```gdscript
var _lbl_def: Label
```

### _lbl_spot

```gdscript
var _lbl_spot: Label
```

### _lbl_range

```gdscript
var _lbl_range: Label
```

### _lbl_morale

```gdscript
var _lbl_morale: Label
```

### _lbl_speed

```gdscript
var _lbl_speed: Label
```

### _lbl_coh

```gdscript
var _lbl_coh: Label
```
