# EnvBehaviorSystem Class Reference

*File:* `scripts/sim/systems/EnvBehaviorSystem.gd`
*Class name:* `EnvBehaviorSystem`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name EnvBehaviorSystem
extends Node
```

## Brief

Computes visibility, loss rolls, and terrain slowdowns; ticks navigation states.

## Detailed Description

Deterministic behaviour depends on an external RNG provided by the caller.

Evaluate and update lost state for a unit.

Evaluate and update slowdown/bog states for a unit.

## Public Member Functions

- [`func register_units(units: Array) -> void`](EnvBehaviorSystem/functions/register_units.md) — Register units and attach navigation state.
- [`func unregister_unit(unit_id: String) -> void`](EnvBehaviorSystem/functions/unregister_unit.md) — Unregister a single unit.
- [`func tick_units(units: Array, dt: float, scenario: Variant, rng: RandomNumberGenerator) -> void`](EnvBehaviorSystem/functions/tick_units.md) — Main tick entry: update per-unit env behaviour.
- [`func set_navigation_bias(unit_id: String, bias: StringName) -> void`](EnvBehaviorSystem/functions/set_navigation_bias.md) — Apply navigation bias change request (roads/cover/shortest).
- [`func _compute_visibility_score(unit: Variant, scenario: Variant) -> float`](EnvBehaviorSystem/functions/_compute_visibility_score.md) — Compute visibility at a position for loss calculations.
- [`func _estimate_path_complexity(unit: Variant) -> float`](EnvBehaviorSystem/functions/_estimate_path_complexity.md) — Determine path complexity/risk for a unit.
- [`func _emit_speed_change(unit_id: String, mult: float) -> void`](EnvBehaviorSystem/functions/_emit_speed_change.md) — Broadcast speed multiplier changes downstream.
- [`func _find_unit_by_id(unit_id: String) -> ScenarioUnit`](EnvBehaviorSystem/functions/_find_unit_by_id.md) — Find a ScenarioUnit by id in the current scenario.
- [`func _random_drift(rng: RandomNumberGenerator) -> Vector2`](EnvBehaviorSystem/functions/_random_drift.md) — Generate a small drift vector used while a unit is lost.
- [`func _terrain_bog_factor(unit: ScenarioUnit) -> float`](EnvBehaviorSystem/functions/_terrain_bog_factor.md) — Terrain multiplier for bog risk based on path grid weight.
- [`func _terrain_loss_factor(unit: ScenarioUnit) -> float`](EnvBehaviorSystem/functions/_terrain_loss_factor.md)
- [`func _has_hold_regroup_order(unit: ScenarioUnit) -> bool`](EnvBehaviorSystem/functions/_has_hold_regroup_order.md) — True when unit has an explicit hold/regroup order metadata set.
- [`func _behaviour_loss_factor(unit: ScenarioUnit) -> float`](EnvBehaviorSystem/functions/_behaviour_loss_factor.md) — Behaviour profile influence on getting lost.
- [`func _weather_loss_factor(scenario: Variant) -> float`](EnvBehaviorSystem/functions/_weather_loss_factor.md) — Weather severity influence on loss risk.
- [`func _near_landmark(unit: ScenarioUnit) -> bool`](EnvBehaviorSystem/functions/_near_landmark.md) — Recovery helper: detect nearby map labels as landmarks.
- [`func _has_friendly_los(unit: ScenarioUnit) -> bool`](EnvBehaviorSystem/functions/_has_friendly_los.md) — True if any friendly has LOS to this unit.
- [`func _request_repath(unit_id: String) -> void`](EnvBehaviorSystem/functions/_request_repath.md) — Ask movement adapter to rebuild the path for a unit.
- [`func _set_stuck_soft(unit_id: String, nav: UnitNavigationState) -> void`](EnvBehaviorSystem/functions/_set_stuck_soft.md) — Mark a unit as stuck and halt movement until engineers assist.
- [`func _apply_drift(unit_id: String, drift: Vector2) -> void`](EnvBehaviorSystem/functions/_apply_drift.md) — Apply or clear drift metadata on the movement adapter.

## Public Attributes

- `MovementAdapter movement_adapter` — Movement adapter used to query path grid and push drift/speed changes.
- `LOSAdapter los_adapter` — LOS adapter used for friendly-visibility recovery checks.
- `VisibilityProfile visibility_profile` — Visibility profile that translates terrain/weather into a 0..1 score.
- `float default_speed_mult_slowed` — Fallback speed multiplier when only slowed (soft ground, minor bog).
- `float default_speed_mult_bogged` — Fallback speed multiplier when bogged.
- `float loss_threshold` — Visibility threshold below which loss checks begin.
- `float regroup_recovery_bonus` — Bonus visibility applied when a Hold/Regroup order is active.
- `float landmark_recovery_radius_m` — Radius (m) to treat map labels as landmarks for recovery.
- `Dictionary _nav_state_by_id`
- `Dictionary _speed_mult_cache`
- `float path_complexity`
- `float threshold`
- `float loss_risk`

## Signals

- `signal unit_lost(unit_id: String)`
- `signal unit_recovered(unit_id: String)`
- `signal unit_bogged(unit_id: String)`
- `signal unit_unbogged(unit_id: String)`
- `signal speed_modifier_changed(unit_id: String, multiplier: float)`
- `signal navigation_bias_changed(unit_id: String, bias: StringName)`

## Member Function Documentation

### register_units

```gdscript
func register_units(units: Array) -> void
```

Register units and attach navigation state.

### unregister_unit

```gdscript
func unregister_unit(unit_id: String) -> void
```

Unregister a single unit.

### tick_units

```gdscript
func tick_units(units: Array, dt: float, scenario: Variant, rng: RandomNumberGenerator) -> void
```

Main tick entry: update per-unit env behaviour.

### set_navigation_bias

```gdscript
func set_navigation_bias(unit_id: String, bias: StringName) -> void
```

Apply navigation bias change request (roads/cover/shortest).

### _compute_visibility_score

```gdscript
func _compute_visibility_score(unit: Variant, scenario: Variant) -> float
```

Compute visibility at a position for loss calculations.

### _estimate_path_complexity

```gdscript
func _estimate_path_complexity(unit: Variant) -> float
```

Determine path complexity/risk for a unit.

### _emit_speed_change

```gdscript
func _emit_speed_change(unit_id: String, mult: float) -> void
```

Broadcast speed multiplier changes downstream.

### _find_unit_by_id

```gdscript
func _find_unit_by_id(unit_id: String) -> ScenarioUnit
```

Find a ScenarioUnit by id in the current scenario.

### _random_drift

```gdscript
func _random_drift(rng: RandomNumberGenerator) -> Vector2
```

Generate a small drift vector used while a unit is lost.

### _terrain_bog_factor

```gdscript
func _terrain_bog_factor(unit: ScenarioUnit) -> float
```

Terrain multiplier for bog risk based on path grid weight.

### _terrain_loss_factor

```gdscript
func _terrain_loss_factor(unit: ScenarioUnit) -> float
```

### _has_hold_regroup_order

```gdscript
func _has_hold_regroup_order(unit: ScenarioUnit) -> bool
```

True when unit has an explicit hold/regroup order metadata set.

### _behaviour_loss_factor

```gdscript
func _behaviour_loss_factor(unit: ScenarioUnit) -> float
```

Behaviour profile influence on getting lost.

### _weather_loss_factor

```gdscript
func _weather_loss_factor(scenario: Variant) -> float
```

Weather severity influence on loss risk.

### _near_landmark

```gdscript
func _near_landmark(unit: ScenarioUnit) -> bool
```

Recovery helper: detect nearby map labels as landmarks.

### _has_friendly_los

```gdscript
func _has_friendly_los(unit: ScenarioUnit) -> bool
```

True if any friendly has LOS to this unit.

### _request_repath

```gdscript
func _request_repath(unit_id: String) -> void
```

Ask movement adapter to rebuild the path for a unit.

### _set_stuck_soft

```gdscript
func _set_stuck_soft(unit_id: String, nav: UnitNavigationState) -> void
```

Mark a unit as stuck and halt movement until engineers assist.

### _apply_drift

```gdscript
func _apply_drift(unit_id: String, drift: Vector2) -> void
```

Apply or clear drift metadata on the movement adapter.

## Member Data Documentation

### movement_adapter

```gdscript
var movement_adapter: MovementAdapter
```

Decorators: `@export`

Movement adapter used to query path grid and push drift/speed changes.

### los_adapter

```gdscript
var los_adapter: LOSAdapter
```

Decorators: `@export`

LOS adapter used for friendly-visibility recovery checks.

### visibility_profile

```gdscript
var visibility_profile: VisibilityProfile
```

Decorators: `@export`

Visibility profile that translates terrain/weather into a 0..1 score.

### default_speed_mult_slowed

```gdscript
var default_speed_mult_slowed: float
```

Decorators: `@export`

Fallback speed multiplier when only slowed (soft ground, minor bog).

### default_speed_mult_bogged

```gdscript
var default_speed_mult_bogged: float
```

Decorators: `@export`

Fallback speed multiplier when bogged.

### loss_threshold

```gdscript
var loss_threshold: float
```

Decorators: `@export`

Visibility threshold below which loss checks begin.

### regroup_recovery_bonus

```gdscript
var regroup_recovery_bonus: float
```

Decorators: `@export`

Bonus visibility applied when a Hold/Regroup order is active.

### landmark_recovery_radius_m

```gdscript
var landmark_recovery_radius_m: float
```

Decorators: `@export`

Radius (m) to treat map labels as landmarks for recovery.

### _nav_state_by_id

```gdscript
var _nav_state_by_id: Dictionary
```

### _speed_mult_cache

```gdscript
var _speed_mult_cache: Dictionary
```

### path_complexity

```gdscript
var path_complexity: float
```

### threshold

```gdscript
var threshold: float
```

### loss_risk

```gdscript
var loss_risk: float
```

## Signal Documentation

### unit_lost

```gdscript
signal unit_lost(unit_id: String)
```

### unit_recovered

```gdscript
signal unit_recovered(unit_id: String)
```

### unit_bogged

```gdscript
signal unit_bogged(unit_id: String)
```

### unit_unbogged

```gdscript
signal unit_unbogged(unit_id: String)
```

### speed_modifier_changed

```gdscript
signal speed_modifier_changed(unit_id: String, multiplier: float)
```

### navigation_bias_changed

```gdscript
signal navigation_bias_changed(unit_id: String, bias: StringName)
```
