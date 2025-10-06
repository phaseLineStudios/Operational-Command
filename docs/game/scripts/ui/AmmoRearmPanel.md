# AmmoRearmPanel Class Reference

*File:* `scripts/ui/AmmoRearmPanel.gd`
*Class name:* `AmmoRearmPanel`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name AmmoRearmPanel
extends Control
```

## Public Member Functions

- [`func load_units(units: Array, depot_stock: Dictionary) -> void`](AmmoRearmPanel/functions/load_units.md)
- [`func _ready() -> void`](AmmoRearmPanel/functions/_ready.md)
- [`func _refresh_units() -> void`](AmmoRearmPanel/functions/_refresh_units.md)
- [`func _on_unit_selected(idx: int) -> void`](AmmoRearmPanel/functions/_on_unit_selected.md)
- [`func _build_controls_for(u: UnitData) -> void`](AmmoRearmPanel/functions/_build_controls_for.md)
- [`func _apply_fill_ratio(ratio: float) -> void`](AmmoRearmPanel/functions/_apply_fill_ratio.md)
- [`func _on_commit() -> void`](AmmoRearmPanel/functions/_on_commit.md)
- [`func _update_depot_label() -> void`](AmmoRearmPanel/functions/_update_depot_label.md)
- [`func _ammo_tooltip(u: UnitData) -> String`](AmmoRearmPanel/functions/_ammo_tooltip.md)
- [`func _add_section_label(title: String) -> void`](AmmoRearmPanel/functions/_add_section_label.md)
- [`func _clear_children(n: Node) -> void`](AmmoRearmPanel/functions/_clear_children.md)

## Public Attributes

- `Array[UnitData] _units`
- `Dictionary _depot`
- `Dictionary _sliders_ammo`
- `Dictionary _sliders_stock`
- `Dictionary _pending`
- `ItemList _lst_units`
- `VBoxContainer _box_ammo`
- `Label _lbl_depot`
- `Button _btn_full`
- `Button _btn_half`
- `Button _btn_commit`
- `HSlider slider`
- `int base`

## Signals

- `signal rearm_committed(units_map: Dictionary, depot_after: Dictionary)` — Emitted when the user commits changes.

## Member Function Documentation

### load_units

```gdscript
func load_units(units: Array, depot_stock: Dictionary) -> void
```

### _ready

```gdscript
func _ready() -> void
```

### _refresh_units

```gdscript
func _refresh_units() -> void
```

### _on_unit_selected

```gdscript
func _on_unit_selected(idx: int) -> void
```

### _build_controls_for

```gdscript
func _build_controls_for(u: UnitData) -> void
```

### _apply_fill_ratio

```gdscript
func _apply_fill_ratio(ratio: float) -> void
```

### _on_commit

```gdscript
func _on_commit() -> void
```

### _update_depot_label

```gdscript
func _update_depot_label() -> void
```

### _ammo_tooltip

```gdscript
func _ammo_tooltip(u: UnitData) -> String
```

### _add_section_label

```gdscript
func _add_section_label(title: String) -> void
```

### _clear_children

```gdscript
func _clear_children(n: Node) -> void
```

## Member Data Documentation

### _units

```gdscript
var _units: Array[UnitData]
```

### _depot

```gdscript
var _depot: Dictionary
```

### _sliders_ammo

```gdscript
var _sliders_ammo: Dictionary
```

### _sliders_stock

```gdscript
var _sliders_stock: Dictionary
```

### _pending

```gdscript
var _pending: Dictionary
```

### _lst_units

```gdscript
var _lst_units: ItemList
```

### _box_ammo

```gdscript
var _box_ammo: VBoxContainer
```

### _lbl_depot

```gdscript
var _lbl_depot: Label
```

### _btn_full

```gdscript
var _btn_full: Button
```

### _btn_half

```gdscript
var _btn_half: Button
```

### _btn_commit

```gdscript
var _btn_commit: Button
```

### slider

```gdscript
var slider: HSlider
```

### base

```gdscript
var base: int
```

## Signal Documentation

### rearm_committed

```gdscript
signal rearm_committed(units_map: Dictionary, depot_after: Dictionary)
```

Emitted when the user commits changes.
units_map example:
{ "alpha": {"small_arms": +12, "stock:small_arms": +50} }
