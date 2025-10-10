# FuelRefuelPanel Class Reference

*File:* `scripts/ui/FuelRefuelPanel.gd`
*Class name:* `FuelRefuelPanel`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name FuelRefuelPanel
extends Control
```

## Public Member Functions

- [`func _ready() -> void`](FuelRefuelPanel/functions/_ready.md)
- [`func _build_rows() -> void`](FuelRefuelPanel/functions/_build_rows.md)
- [`func _row_label_for(su: ScenarioUnit, st: UnitFuelState, missing: float) -> String`](FuelRefuelPanel/functions/_row_label_for.md)
- [`func _update_depot_label() -> void`](FuelRefuelPanel/functions/_update_depot_label.md)
- [`func _on_full() -> void`](FuelRefuelPanel/functions/_on_full.md)
- [`func _on_half() -> void`](FuelRefuelPanel/functions/_on_half.md)
- [`func _on_slider_changed(_v: float, uid: String) -> void`](FuelRefuelPanel/functions/_on_slider_changed.md)
- [`func _planned_total_except(skip_uid: String) -> float`](FuelRefuelPanel/functions/_planned_total_except.md)
- [`func _value_labels_refresh() -> void`](FuelRefuelPanel/functions/_value_labels_refresh.md)
- [`func _on_commit() -> void`](FuelRefuelPanel/functions/_on_commit.md)
- [`func _apply_refuel(uid: String, amount: float) -> float`](FuelRefuelPanel/functions/_apply_refuel.md)

## Public Attributes

- `float slider_step`
- `bool show_missing_in_label`
- `float width_px`
- `float row_label_min_w`
- `float value_label_min_w`
- `int compact_font_size`
- `FuelSystem _fuel`
- `Array[ScenarioUnit] _units`
- `float _depot`
- `Dictionary[String, HSlider] _sliders`
- `Dictionary[String, Label] _value_labels`
- `Label _title`
- `Label _depot_lbl`
- `VBoxContainer _rows_box`
- `Button _btn_full`
- `Button _btn_half`
- `Button _btn_cancel`
- `Button _btn_commit`

## Signals

- `signal refuel_committed(plan: Dictionary[String, float], depot_after: float)` — Minimal refuel panel (ammo-rearm style):
choose per-unit amounts and consume a shared depot stock..

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _build_rows

```gdscript
func _build_rows() -> void
```

### _row_label_for

```gdscript
func _row_label_for(su: ScenarioUnit, st: UnitFuelState, missing: float) -> String
```

### _update_depot_label

```gdscript
func _update_depot_label() -> void
```

### _on_full

```gdscript
func _on_full() -> void
```

### _on_half

```gdscript
func _on_half() -> void
```

### _on_slider_changed

```gdscript
func _on_slider_changed(_v: float, uid: String) -> void
```

### _planned_total_except

```gdscript
func _planned_total_except(skip_uid: String) -> float
```

### _value_labels_refresh

```gdscript
func _value_labels_refresh() -> void
```

### _on_commit

```gdscript
func _on_commit() -> void
```

### _apply_refuel

```gdscript
func _apply_refuel(uid: String, amount: float) -> float
```

## Member Data Documentation

### slider_step

```gdscript
var slider_step: float
```

### show_missing_in_label

```gdscript
var show_missing_in_label: bool
```

### width_px

```gdscript
var width_px: float
```

### row_label_min_w

```gdscript
var row_label_min_w: float
```

### value_label_min_w

```gdscript
var value_label_min_w: float
```

### compact_font_size

```gdscript
var compact_font_size: int
```

### _fuel

```gdscript
var _fuel: FuelSystem
```

### _units

```gdscript
var _units: Array[ScenarioUnit]
```

### _depot

```gdscript
var _depot: float
```

### _sliders

```gdscript
var _sliders: Dictionary[String, HSlider]
```

### _value_labels

```gdscript
var _value_labels: Dictionary[String, Label]
```

### _title

```gdscript
var _title: Label
```

### _depot_lbl

```gdscript
var _depot_lbl: Label
```

### _rows_box

```gdscript
var _rows_box: VBoxContainer
```

### _btn_full

```gdscript
var _btn_full: Button
```

### _btn_half

```gdscript
var _btn_half: Button
```

### _btn_cancel

```gdscript
var _btn_cancel: Button
```

### _btn_commit

```gdscript
var _btn_commit: Button
```

## Signal Documentation

### refuel_committed

```gdscript
signal refuel_committed(plan: Dictionary[String, float], depot_after: float)
```

Minimal refuel panel (ammo-rearm style):
choose per-unit amounts and consume a shared depot stock..
