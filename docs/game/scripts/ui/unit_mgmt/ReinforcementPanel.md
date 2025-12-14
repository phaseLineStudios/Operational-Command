# ReinforcementPanel Class Reference

*File:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd`
*Class name:* `ReinforcementPanel`
*Inherits:* `VBoxContainer`

## Synopsis

```gdscript
class_name ReinforcementPanel
extends VBoxContainer
```

## Public Member Functions

- [`func _ready() -> void`](ReinforcementPanel/functions/_ready.md)
- [`func set_units(units: Array[UnitData], unit_strengths: Dictionary = {}) -> void`](ReinforcementPanel/functions/set_units.md) — Provide the list of units to display.
- [`func set_pool(amount: int) -> void`](ReinforcementPanel/functions/set_pool.md) — Set available replacements in the pool and refresh UI.
- [`func reset_pending() -> void`](ReinforcementPanel/functions/reset_pending.md) — Clear the pending plan back to zero for all units.
- [`func commit() -> void`](ReinforcementPanel/functions/commit.md) — Emit the current plan to the owner.
- [`func _build_rows() -> void`](ReinforcementPanel/functions/_build_rows.md) — Create row widgets for current units.
- [`func _disable_row(w: RowWidgets, disabled: bool) -> void`](ReinforcementPanel/functions/_disable_row.md) — Enable/disable row interactivity.
- [`func _update_all_rows_state() -> void`](ReinforcementPanel/functions/_update_all_rows_state.md) — Refresh values, slider ranges, title/colour, and badge for all rows.
- [`func _update_pool_labels() -> void`](ReinforcementPanel/functions/_update_pool_labels.md) — Update the pool label.
- [`func _update_commit_enabled() -> void`](ReinforcementPanel/functions/_update_commit_enabled.md) — Enable Commit button only when there is any planned change.
- [`func _pending_sum() -> int`](ReinforcementPanel/functions/_pending_sum.md) — Sum of all pending allocations.
- [`func _nudge(uid: String, delta: int) -> void`](ReinforcementPanel/functions/_nudge.md) — Change planned amount by a delta.
- [`func _set_amount(uid: String, target: int) -> void`](ReinforcementPanel/functions/_set_amount.md) — Set planned amount for a unit (clamped to capacity and pool).
- [`func _emit_preview(uid: String, amt: int) -> void`](ReinforcementPanel/functions/_emit_preview.md) — Emit preview signal.
- [`func _find_unit(uid: String) -> UnitData`](ReinforcementPanel/functions/_find_unit.md) — Find a UnitData by id.
- [`func _clear_children(n: Node) -> void`](ReinforcementPanel/functions/_clear_children.md) — Clear all children from a container.
- [`func refresh_from_units() -> void`](ReinforcementPanel/functions/refresh_from_units.md) — Public: re-read UnitData and refresh all UI from the current state.

## Public Attributes

- `float understrength_threshold`
- `float slider_step`
- `float row_label_min_w`
- `float value_label_min_w`
- `Array[UnitData] _units`
- `int _pool_total`
- `int _pool_remaining`
- `Dictionary[String, int] _pending`
- `Dictionary[String, RowWidgets] _rows`
- `Dictionary[String, float] _unit_strength` — Temporary: tracks current strength per unit for campaign persistence (to be replaced)
- `Label _lbl_pool`
- `VBoxContainer _rows_box`
- `Button _btn_commit`
- `Button _btn_reset`
- `VBoxContainer box`
- `Label title`
- `UnitStrengthBadge badge`
- `Label current_max_label`
- `Button minus`
- `Label value`
- `Button plus`
- `HSlider slider`
- `Label max_lbl`
- `String base_title`

## Signals

- `signal reinforcement_preview_changed(unit_id: String, new_amount: int)` — Panel to allocate pre-mission personnel reinforcements from a shared pool.
- `signal reinforcement_committed(assignments: Dictionary[String, int])`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### set_units

```gdscript
func set_units(units: Array[UnitData], unit_strengths: Dictionary = {}) -> void
```

Provide the list of units to display. Rebuild rows and clear any plan.
`units` Array of UnitData templates.
`unit_strengths` Optional dictionary mapping unit_id -> current_strength (for campaign).

### set_pool

```gdscript
func set_pool(amount: int) -> void
```

Set available replacements in the pool and refresh UI.

### reset_pending

```gdscript
func reset_pending() -> void
```

Clear the pending plan back to zero for all units.

### commit

```gdscript
func commit() -> void
```

Emit the current plan to the owner. Does not mutate UnitData here.

### _build_rows

```gdscript
func _build_rows() -> void
```

Create row widgets for current units.

### _disable_row

```gdscript
func _disable_row(w: RowWidgets, disabled: bool) -> void
```

Enable/disable row interactivity.

### _update_all_rows_state

```gdscript
func _update_all_rows_state() -> void
```

Refresh values, slider ranges, title/colour, and badge for all rows.

### _update_pool_labels

```gdscript
func _update_pool_labels() -> void
```

Update the pool label.

### _update_commit_enabled

```gdscript
func _update_commit_enabled() -> void
```

Enable Commit button only when there is any planned change.

### _pending_sum

```gdscript
func _pending_sum() -> int
```

Sum of all pending allocations.

### _nudge

```gdscript
func _nudge(uid: String, delta: int) -> void
```

Change planned amount by a delta.

### _set_amount

```gdscript
func _set_amount(uid: String, target: int) -> void
```

Set planned amount for a unit (clamped to capacity and pool).

### _emit_preview

```gdscript
func _emit_preview(uid: String, amt: int) -> void
```

Emit preview signal.

### _find_unit

```gdscript
func _find_unit(uid: String) -> UnitData
```

Find a UnitData by id.

### _clear_children

```gdscript
func _clear_children(n: Node) -> void
```

Clear all children from a container.

### refresh_from_units

```gdscript
func refresh_from_units() -> void
```

Public: re-read UnitData and refresh all UI from the current state.

## Member Data Documentation

### understrength_threshold

```gdscript
var understrength_threshold: float
```

### slider_step

```gdscript
var slider_step: float
```

### row_label_min_w

```gdscript
var row_label_min_w: float
```

### value_label_min_w

```gdscript
var value_label_min_w: float
```

### _units

```gdscript
var _units: Array[UnitData]
```

### _pool_total

```gdscript
var _pool_total: int
```

### _pool_remaining

```gdscript
var _pool_remaining: int
```

### _pending

```gdscript
var _pending: Dictionary[String, int]
```

### _rows

```gdscript
var _rows: Dictionary[String, RowWidgets]
```

### _unit_strength

```gdscript
var _unit_strength: Dictionary[String, float]
```

Temporary: tracks current strength per unit for campaign persistence (to be replaced)

### _lbl_pool

```gdscript
var _lbl_pool: Label
```

### _rows_box

```gdscript
var _rows_box: VBoxContainer
```

### _btn_commit

```gdscript
var _btn_commit: Button
```

### _btn_reset

```gdscript
var _btn_reset: Button
```

### box

```gdscript
var box: VBoxContainer
```

### title

```gdscript
var title: Label
```

### badge

```gdscript
var badge: UnitStrengthBadge
```

### current_max_label

```gdscript
var current_max_label: Label
```

### minus

```gdscript
var minus: Button
```

### value

```gdscript
var value: Label
```

### plus

```gdscript
var plus: Button
```

### slider

```gdscript
var slider: HSlider
```

### max_lbl

```gdscript
var max_lbl: Label
```

### base_title

```gdscript
var base_title: String
```

## Signal Documentation

### reinforcement_preview_changed

```gdscript
signal reinforcement_preview_changed(unit_id: String, new_amount: int)
```

Panel to allocate pre-mission personnel reinforcements from a shared pool.

### reinforcement_committed

```gdscript
signal reinforcement_committed(assignments: Dictionary[String, int])
```
