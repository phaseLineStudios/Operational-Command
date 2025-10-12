# FuelSystem Class Reference

*File:* `scripts/sim/systems/FuelSystem.gd`
*Class name:* `FuelSystem`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name FuelSystem
extends Node
```

## Brief

Mission-scoped fuel consumption and refueling based on ScenarioUnit movement.

## Detailed Description

Responsibilities
- Track per-unit fuel state and ScenarioUnit positions.
- Drain fuel per second (idle) and per meter (movement),
with optional terrain and slope multipliers.
- Emit threshold events and immobilize at empty by pausing ScenarioUnit.
- Proximity refuel from tanker units with throughput["fuel"] stock.
- Provide a speed multiplier so movement can slow at CRITICAL and stop at EMPTY.Y.

## Public Member Functions

- [`func _ready() -> void`](FuelSystem/functions/_ready.md)
- [`func register_scenario_unit(su: ScenarioUnit, state: UnitFuelState = null) -> void`](FuelSystem/functions/register_scenario_unit.md) — Public API
- [`func unregister_unit(unit_id: String) -> void`](FuelSystem/functions/unregister_unit.md)
- [`func get_fuel_state(unit_id: String) -> UnitFuelState`](FuelSystem/functions/get_fuel_state.md)
- [`func is_low(unit_id: String) -> bool`](FuelSystem/functions/is_low.md)
- [`func is_critical(unit_id: String) -> bool`](FuelSystem/functions/is_critical.md)
- [`func is_empty(unit_id: String) -> bool`](FuelSystem/functions/is_empty.md)
- [`func speed_mult(unit_id: String) -> float`](FuelSystem/functions/speed_mult.md)
- [`func tick(delta: float) -> void`](FuelSystem/functions/tick.md)
- [`func _on_move_progress(pos_m: Vector2, _eta: float, uid: String) -> void`](FuelSystem/functions/_on_move_progress.md) — Movement signal handlers
- [`func _on_move_started(_dest: Vector2, uid: String) -> void`](FuelSystem/functions/_on_move_started.md)
- [`func _on_move_arrived(_dest: Vector2, uid: String) -> void`](FuelSystem/functions/_on_move_arrived.md)
- [`func _on_move_blocked(_reason: String, uid: String) -> void`](FuelSystem/functions/_on_move_blocked.md)
- [`func _on_move_paused(uid: String) -> void`](FuelSystem/functions/_on_move_paused.md)
- [`func _on_move_resumed(uid: String) -> void`](FuelSystem/functions/_on_move_resumed.md)
- [`func _consume_tick(delta: float) -> void`](FuelSystem/functions/_consume_tick.md) — Fuel drain
- [`func _check_thresholds(uid: String, before: float, after: float, su: ScenarioUnit) -> void`](FuelSystem/functions/_check_thresholds.md)
- [`func _terrain_slope_multiplier(a: Vector2, b: Vector2) -> float`](FuelSystem/functions/_terrain_slope_multiplier.md) — Terrain and slope
- [`func _surface_mult_at(p_m: Vector2) -> float`](FuelSystem/functions/_surface_mult_at.md)
- [`func _elevation_delta_norm(a: Vector2, b: Vector2) -> float`](FuelSystem/functions/_elevation_delta_norm.md)
- [`func _is_tanker(u: UnitData) -> bool`](FuelSystem/functions/_is_tanker.md) — Refuel logic
- [`func _needs_fuel(su: ScenarioUnit) -> bool`](FuelSystem/functions/_needs_fuel.md)
- [`func _has_stock(su: ScenarioUnit) -> bool`](FuelSystem/functions/_has_stock.md)
- [`func _within_radius(src: ScenarioUnit, dst: ScenarioUnit) -> bool`](FuelSystem/functions/_within_radius.md)
- [`func _pick_link_for(dst: ScenarioUnit) -> String`](FuelSystem/functions/_pick_link_for.md)
- [`func _begin_link(src_id: String, dst_id: String) -> void`](FuelSystem/functions/_begin_link.md)
- [`func _finish_link(dst_id: String) -> void`](FuelSystem/functions/_finish_link.md)
- [`func _refuel_tick(delta: float) -> void`](FuelSystem/functions/_refuel_tick.md)
- [`func add_fuel(uid: String, amount: float) -> float`](FuelSystem/functions/add_fuel.md) — Directly add fuel to a unit (UI/depot use).
- [`func fuel_debug(uid: String) -> Dictionary`](FuelSystem/functions/fuel_debug.md) — Compact UI snapshot for overlays / panels.

## Public Attributes

- `FuelProfile fuel_profile` — Defaults and terrain hooks
- `TerrainData terrain_data` — Optional terrain data for surface and slope multipliers.
- `float critical_speed_mult` — Movement penalty at CRITICAL fuel.
- `Dictionary[String, ScenarioUnit] _su` — Registered units and state (typed dictionaries to avoid Variant)
- `Dictionary[String, UnitFuelState] _fuel`
- `Dictionary[String, Vector2] _pos`
- `Dictionary[String, Vector2] _prev`
- `Dictionary[String, bool] _immobilized`
- `Dictionary[String, String] _active_links` — Active refuel links and fractional carry-over
- `Dictionary[String, float] _xfer_accum`

## Signals

- `signal fuel_low(unit_id: String)` — Threshold and refuel lifecycle signals
- `signal fuel_critical(unit_id: String)`
- `signal fuel_empty(unit_id: String)`
- `signal refuel_started(src_unit_id: String, dst_unit_id: String)`
- `signal refuel_completed(src_unit_id: String, dst_unit_id: String)`
- `signal unit_immobilized_fuel_out(unit_id: String)` — Mobility signals
- `signal unit_mobilized_after_refuel(unit_id: String)`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### register_scenario_unit

```gdscript
func register_scenario_unit(su: ScenarioUnit, state: UnitFuelState = null) -> void
```

Public API

### unregister_unit

```gdscript
func unregister_unit(unit_id: String) -> void
```

### get_fuel_state

```gdscript
func get_fuel_state(unit_id: String) -> UnitFuelState
```

### is_low

```gdscript
func is_low(unit_id: String) -> bool
```

### is_critical

```gdscript
func is_critical(unit_id: String) -> bool
```

### is_empty

```gdscript
func is_empty(unit_id: String) -> bool
```

### speed_mult

```gdscript
func speed_mult(unit_id: String) -> float
```

### tick

```gdscript
func tick(delta: float) -> void
```

### _on_move_progress

```gdscript
func _on_move_progress(pos_m: Vector2, _eta: float, uid: String) -> void
```

Movement signal handlers

### _on_move_started

```gdscript
func _on_move_started(_dest: Vector2, uid: String) -> void
```

### _on_move_arrived

```gdscript
func _on_move_arrived(_dest: Vector2, uid: String) -> void
```

### _on_move_blocked

```gdscript
func _on_move_blocked(_reason: String, uid: String) -> void
```

### _on_move_paused

```gdscript
func _on_move_paused(uid: String) -> void
```

### _on_move_resumed

```gdscript
func _on_move_resumed(uid: String) -> void
```

### _consume_tick

```gdscript
func _consume_tick(delta: float) -> void
```

Fuel drain

### _check_thresholds

```gdscript
func _check_thresholds(uid: String, before: float, after: float, su: ScenarioUnit) -> void
```

### _terrain_slope_multiplier

```gdscript
func _terrain_slope_multiplier(a: Vector2, b: Vector2) -> float
```

Terrain and slope

### _surface_mult_at

```gdscript
func _surface_mult_at(p_m: Vector2) -> float
```

### _elevation_delta_norm

```gdscript
func _elevation_delta_norm(a: Vector2, b: Vector2) -> float
```

### _is_tanker

```gdscript
func _is_tanker(u: UnitData) -> bool
```

Refuel logic

### _needs_fuel

```gdscript
func _needs_fuel(su: ScenarioUnit) -> bool
```

### _has_stock

```gdscript
func _has_stock(su: ScenarioUnit) -> bool
```

### _within_radius

```gdscript
func _within_radius(src: ScenarioUnit, dst: ScenarioUnit) -> bool
```

### _pick_link_for

```gdscript
func _pick_link_for(dst: ScenarioUnit) -> String
```

### _begin_link

```gdscript
func _begin_link(src_id: String, dst_id: String) -> void
```

### _finish_link

```gdscript
func _finish_link(dst_id: String) -> void
```

### _refuel_tick

```gdscript
func _refuel_tick(delta: float) -> void
```

### add_fuel

```gdscript
func add_fuel(uid: String, amount: float) -> float
```

Directly add fuel to a unit (UI/depot use). Returns amount actually added.

### fuel_debug

```gdscript
func fuel_debug(uid: String) -> Dictionary
```

Compact UI snapshot for overlays / panels.

## Member Data Documentation

### fuel_profile

```gdscript
var fuel_profile: FuelProfile
```

Decorators: `@export`

Defaults and terrain hooks

### terrain_data

```gdscript
var terrain_data: TerrainData
```

Decorators: `@export`

Optional terrain data for surface and slope multipliers.

### critical_speed_mult

```gdscript
var critical_speed_mult: float
```

Decorators: `@export_range(0.1, 1.0, 0.05)`

Movement penalty at CRITICAL fuel. 1.0 means no penalty.

### _su

```gdscript
var _su: Dictionary[String, ScenarioUnit]
```

Registered units and state (typed dictionaries to avoid Variant)

### _fuel

```gdscript
var _fuel: Dictionary[String, UnitFuelState]
```

### _pos

```gdscript
var _pos: Dictionary[String, Vector2]
```

### _prev

```gdscript
var _prev: Dictionary[String, Vector2]
```

### _immobilized

```gdscript
var _immobilized: Dictionary[String, bool]
```

### _active_links

```gdscript
var _active_links: Dictionary[String, String]
```

Active refuel links and fractional carry-over

### _xfer_accum

```gdscript
var _xfer_accum: Dictionary[String, float]
```

## Signal Documentation

### fuel_low

```gdscript
signal fuel_low(unit_id: String)
```

Threshold and refuel lifecycle signals

### fuel_critical

```gdscript
signal fuel_critical(unit_id: String)
```

### fuel_empty

```gdscript
signal fuel_empty(unit_id: String)
```

### refuel_started

```gdscript
signal refuel_started(src_unit_id: String, dst_unit_id: String)
```

### refuel_completed

```gdscript
signal refuel_completed(src_unit_id: String, dst_unit_id: String)
```

### unit_immobilized_fuel_out

```gdscript
signal unit_immobilized_fuel_out(unit_id: String)
```

Mobility signals

### unit_mobilized_after_refuel

```gdscript
signal unit_mobilized_after_refuel(unit_id: String)
```
