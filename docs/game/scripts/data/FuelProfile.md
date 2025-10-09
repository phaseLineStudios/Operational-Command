# FuelProfile Class Reference

*File:* `scripts/data/FuelProfile.gd`
*Class name:* `FuelProfile`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name FuelProfile
extends Resource
```

## Public Member Functions

- [`func apply_defaults_if_missing(state: UnitFuelState) -> void`](FuelProfile/functions/apply_defaults_if_missing.md) — Ensures that a given UnitFuelState has valid default values for all its fuel properties.

## Public Attributes

- `float default_capacity` — Defaults per unit class and simple slope multiplier.
- `float default_low_threshold`
- `float default_critical_threshold`
- `float default_idle_rate_per_s`
- `float default_move_rate_per_m`
- `float slope_k` — Slope factor applied as (1.0 + slope_k * normalized_slope).

## Member Function Documentation

### apply_defaults_if_missing

```gdscript
func apply_defaults_if_missing(state: UnitFuelState) -> void
```

Ensures that a given UnitFuelState has valid default values for all its fuel properties.
If any parameter (e.g., capacity, thresholds, or consumption rates) is unset or zero,
this function replaces it with predefined default values.

## Member Data Documentation

### default_capacity

```gdscript
var default_capacity: float
```

Defaults per unit class and simple slope multiplier.

### default_low_threshold

```gdscript
var default_low_threshold: float
```

### default_critical_threshold

```gdscript
var default_critical_threshold: float
```

### default_idle_rate_per_s

```gdscript
var default_idle_rate_per_s: float
```

### default_move_rate_per_m

```gdscript
var default_move_rate_per_m: float
```

### slope_k

```gdscript
var slope_k: float
```

Slope factor applied as (1.0 + slope_k * normalized_slope).
