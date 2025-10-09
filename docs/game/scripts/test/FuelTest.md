# FuelTest Class Reference

*File:* `scripts/test/FuelTest.gd`
*Inherits:* `Control`

## Synopsis

```gdscript
extends Control
```

## Public Member Functions

- [`func _ready() -> void`](FuelTest/functions/_ready.md)
- [`func _process(delta: float) -> void`](FuelTest/functions/_process.md)
- [`func _wire_ui() -> void`](FuelTest/functions/_wire_ui.md)
- [`func _ensure_panel_below_hud_block() -> void`](FuelTest/functions/_ensure_panel_below_hud_block.md)
- [`func _find_button(paths: PackedStringArray) -> Button`](FuelTest/functions/_find_button.md)
- [`func _find_label(paths: PackedStringArray) -> Label`](FuelTest/functions/_find_label.md)
- [`func _find_panel(paths: PackedStringArray) -> FuelRefuelPanel`](FuelTest/functions/_find_panel.md)
- [`func _update_labels() -> void`](FuelTest/functions/_update_labels.md)
- [`func _on_toggle_move() -> void`](FuelTest/functions/_on_toggle_move.md)
- [`func _on_drain() -> void`](FuelTest/functions/_on_drain.md)
- [`func _on_tp() -> void`](FuelTest/functions/_on_tp.md)
- [`func _on_topup() -> void`](FuelTest/functions/_on_topup.md)
- [`func _on_panel_done(_plan: Dictionary, depot_after: float) -> void`](FuelTest/functions/_on_panel_done.md)
- [`func _kph_to_mps(kph: float) -> float`](FuelTest/functions/_kph_to_mps.md)
- [`func _now_s() -> float`](FuelTest/functions/_now_s.md)

## Public Attributes

- `Button btn_move`
- `Button btn_drain`
- `Button btn_tp`
- `Button btn_topup`
- `Label lbl_rx`
- `Label lbl_tk`
- `Label lbl_spd`
- `FuelRefuelPanel panel`
- `FuelSystem fuel`
- `ScenarioUnit rx`
- `ScenarioUnit tk`
- `UnitFuelState rx_state`
- `bool move_enabled`
- `float depot_stock`
- `float _last_time_s`
- `Vector2 _prev_pos_rx`
- `float _ema_speed_rx`
- `Vector2 base_pos`
- `Vector2 base_size`
- `float left`
- `float top`

## Public Constants

- `const RX_SPEED_KPH: float` — Stand-alone test for the Fuel system (panel placed under the test HUD block).
- `const RX_CAP: float`
- `const RX_START: float`
- `const TK_STOCK_START: int`
- `const TK_RATE: float`
- `const TK_RADIUS: float`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _process

```gdscript
func _process(delta: float) -> void
```

### _wire_ui

```gdscript
func _wire_ui() -> void
```

### _ensure_panel_below_hud_block

```gdscript
func _ensure_panel_below_hud_block() -> void
```

### _find_button

```gdscript
func _find_button(paths: PackedStringArray) -> Button
```

### _find_label

```gdscript
func _find_label(paths: PackedStringArray) -> Label
```

### _find_panel

```gdscript
func _find_panel(paths: PackedStringArray) -> FuelRefuelPanel
```

### _update_labels

```gdscript
func _update_labels() -> void
```

### _on_toggle_move

```gdscript
func _on_toggle_move() -> void
```

### _on_drain

```gdscript
func _on_drain() -> void
```

### _on_tp

```gdscript
func _on_tp() -> void
```

### _on_topup

```gdscript
func _on_topup() -> void
```

### _on_panel_done

```gdscript
func _on_panel_done(_plan: Dictionary, depot_after: float) -> void
```

### _kph_to_mps

```gdscript
func _kph_to_mps(kph: float) -> float
```

### _now_s

```gdscript
func _now_s() -> float
```

## Member Data Documentation

### btn_move

```gdscript
var btn_move: Button
```

### btn_drain

```gdscript
var btn_drain: Button
```

### btn_tp

```gdscript
var btn_tp: Button
```

### btn_topup

```gdscript
var btn_topup: Button
```

### lbl_rx

```gdscript
var lbl_rx: Label
```

### lbl_tk

```gdscript
var lbl_tk: Label
```

### lbl_spd

```gdscript
var lbl_spd: Label
```

### panel

```gdscript
var panel: FuelRefuelPanel
```

### fuel

```gdscript
var fuel: FuelSystem
```

### rx

```gdscript
var rx: ScenarioUnit
```

### tk

```gdscript
var tk: ScenarioUnit
```

### rx_state

```gdscript
var rx_state: UnitFuelState
```

### move_enabled

```gdscript
var move_enabled: bool
```

### depot_stock

```gdscript
var depot_stock: float
```

### _last_time_s

```gdscript
var _last_time_s: float
```

### _prev_pos_rx

```gdscript
var _prev_pos_rx: Vector2
```

### _ema_speed_rx

```gdscript
var _ema_speed_rx: float
```

### base_pos

```gdscript
var base_pos: Vector2
```

### base_size

```gdscript
var base_size: Vector2
```

### left

```gdscript
var left: float
```

### top

```gdscript
var top: float
```

## Constant Documentation

### RX_SPEED_KPH

```gdscript
const RX_SPEED_KPH: float
```

Stand-alone test for the Fuel system (panel placed under the test HUD block).

### RX_CAP

```gdscript
const RX_CAP: float
```

### RX_START

```gdscript
const RX_START: float
```

### TK_STOCK_START

```gdscript
const TK_STOCK_START: int
```

### TK_RATE

```gdscript
const TK_RATE: float
```

### TK_RADIUS

```gdscript
const TK_RADIUS: float
```
