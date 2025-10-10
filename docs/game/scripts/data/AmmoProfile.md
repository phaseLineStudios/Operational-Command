# AmmoProfile Class Reference

*File:* `scripts/data/AmmoProfile.gd`
*Class name:* `AmmoProfile`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name AmmoProfile
extends Resource
```

## Brief

Resource that holds default ammo capacities and thresholds.

## Detailed Description

Used by AmmoSystem when newly-registered units are missing values.

## Public Member Functions

- [`func apply_defaults_if_missing(u: UnitData) -> void`](AmmoProfile/functions/apply_defaults_if_missing.md) — Fill in caps/state/thresholds if the UnitData is missing them.

## Public Attributes

- `Dictionary default_caps` — Default per-type ammo capacities.
- `float default_low_threshold` — Default low threshold (ratio of current/cap).
- `float default_critical_threshold` — Default critical threshold (ratio of current/cap).

## Member Function Documentation

### apply_defaults_if_missing

```gdscript
func apply_defaults_if_missing(u: UnitData) -> void
```

Fill in caps/state/thresholds if the UnitData is missing them.

## Member Data Documentation

### default_caps

```gdscript
var default_caps: Dictionary
```

Decorators: `@export`

Default per-type ammo capacities.

### default_low_threshold

```gdscript
var default_low_threshold: float
```

Decorators: `@export_range(0.0, 1.0, 0.01)`

Default low threshold (ratio of current/cap).

### default_critical_threshold

```gdscript
var default_critical_threshold: float
```

Decorators: `@export_range(0.0, 1.0, 0.01)`

Default critical threshold (ratio of current/cap).
