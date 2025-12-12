# UnitNavigationState Class Reference

*File:* `scripts/data/UnitNavigationState.gd`
*Class name:* `UnitNavigationState`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name UnitNavigationState
extends Resource
```

## Public Member Functions

- [`func reset() -> void`](UnitNavigationState/functions/reset.md) — Reset all transient navigation flags.
- [`func set_lost(state: bool, drift: Vector2 = Vector2.ZERO) -> void`](UnitNavigationState/functions/set_lost.md) — Mark unit as lost with an optional drift vector.
- [`func set_nav_state(state: NavState) -> void`](UnitNavigationState/functions/set_nav_state.md) — Set bogged/slow state and timers; resets when back to NORMAL.
- [`func tick_timers(dt: float) -> void`](UnitNavigationState/functions/tick_timers.md) — Advance timers for lost/bogged state.
- [`func set_navigation_bias(bias: StringName) -> void`](UnitNavigationState/functions/set_navigation_bias.md) — Update navigation bias preference.

## Public Attributes

- `NavState nav_state`
- `bool is_lost`
- `Vector2 drift_vector`
- `float lost_timer_s`
- `float bogged_timer_s`
- `StringName navigation_bias`

## Enumerations

- `enum NavState` — Runtime navigation flags and timers for environment-aware movement.

## Member Function Documentation

### reset

```gdscript
func reset() -> void
```

Reset all transient navigation flags.

### set_lost

```gdscript
func set_lost(state: bool, drift: Vector2 = Vector2.ZERO) -> void
```

Mark unit as lost with an optional drift vector.

### set_nav_state

```gdscript
func set_nav_state(state: NavState) -> void
```

Set bogged/slow state and timers; resets when back to NORMAL.

### tick_timers

```gdscript
func tick_timers(dt: float) -> void
```

Advance timers for lost/bogged state.

### set_navigation_bias

```gdscript
func set_navigation_bias(bias: StringName) -> void
```

Update navigation bias preference.

## Member Data Documentation

### nav_state

```gdscript
var nav_state: NavState
```

### is_lost

```gdscript
var is_lost: bool
```

### drift_vector

```gdscript
var drift_vector: Vector2
```

### lost_timer_s

```gdscript
var lost_timer_s: float
```

### bogged_timer_s

```gdscript
var bogged_timer_s: float
```

### navigation_bias

```gdscript
var navigation_bias: StringName
```

## Enumeration Type Documentation

### NavState

```gdscript
enum NavState
```

Runtime navigation flags and timers for environment-aware movement.
This is a stub; flesh out fields and helpers when implementing EnvBehaviorSystem.
