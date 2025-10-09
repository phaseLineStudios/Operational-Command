# UnitFuelState Class Reference

*File:* `scripts/data/UnitFuelState.gd`
*Class name:* `UnitFuelState`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name UnitFuelState
extends Resource
```

## Public Member Functions

- [`func ratio() -> float`](UnitFuelState/functions/ratio.md) — Calculates and returns the current fuel ratio for the unit.

## Public Attributes

- `float fuel_capacity` — Per-unit fuel state and rates used by FuelSystem.
- `float state_fuel`
- `float fuel_low_threshold`
- `float fuel_critical_threshold`
- `float fuel_idle_rate_per_s` — Idle burn in fuel units per second while not moving.
- `float fuel_move_rate_per_m` — Movement burn in fuel units per meter traveled.

## Member Function Documentation

### ratio

```gdscript
func ratio() -> float
```

Calculates and returns the current fuel ratio for the unit.
The value is clamped between 0.0 and 1.0 to represent the percentage of fuel remaining.
Returns 0.0 if the unit has no valid fuel capacity defined.

## Member Data Documentation

### fuel_capacity

```gdscript
var fuel_capacity: float
```

Per-unit fuel state and rates used by FuelSystem.

### state_fuel

```gdscript
var state_fuel: float
```

### fuel_low_threshold

```gdscript
var fuel_low_threshold: float
```

### fuel_critical_threshold

```gdscript
var fuel_critical_threshold: float
```

### fuel_idle_rate_per_s

```gdscript
var fuel_idle_rate_per_s: float
```

Idle burn in fuel units per second while not moving.

### fuel_move_rate_per_m

```gdscript
var fuel_move_rate_per_m: float
```

Movement burn in fuel units per meter traveled.
