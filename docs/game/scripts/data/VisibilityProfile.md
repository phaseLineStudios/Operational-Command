# VisibilityProfile Class Reference

*File:* `scripts/data/VisibilityProfile.gd`
*Class name:* `VisibilityProfile`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name VisibilityProfile
extends Resource
```

## Brief

Configuration for local visibility scoring and loss thresholds.

## Detailed Description

This is a stub; populate fields and logic when implementing EnvBehaviorSystem.

Compute a normalized visibility score given terrain/weather context.
`terrain_renderer` TerrainRender reference.
`pos_m` Position in meters.
`scenario_weather` Dictionary or ScenarioData weather fields.
`behaviour` Behaviour enum or int to bias risk.
[return] Float visibility score (0..1).

## Public Member Functions

- [`func weather_severity_from_scenario(scenario_weather: Variant) -> float`](VisibilityProfile/functions/weather_severity_from_scenario.md) — Optional helper to derive weather severity from a ScenarioData.
- [`func behaviour_visibility_multiplier(behaviour: int) -> float`](VisibilityProfile/functions/behaviour_visibility_multiplier.md) — Optional helper to apply behaviour-based modifiers.

## Public Attributes

- `float base_visibility_threshold`
- `float fog_visibility_penalty`
- `float night_visibility_penalty`
- `float score`
- `Dictionary surf`
- `Variant brush`
- `float conceal`
- `float weather_severity`
- `int hour`
- `float night_mult`

## Member Function Documentation

### weather_severity_from_scenario

```gdscript
func weather_severity_from_scenario(scenario_weather: Variant) -> float
```

Optional helper to derive weather severity from a ScenarioData.
Convert fog/rain into a 0..1 severity used by loss/visibility logic.

### behaviour_visibility_multiplier

```gdscript
func behaviour_visibility_multiplier(behaviour: int) -> float
```

Optional helper to apply behaviour-based modifiers.

## Member Data Documentation

### base_visibility_threshold

```gdscript
var base_visibility_threshold: float
```

### fog_visibility_penalty

```gdscript
var fog_visibility_penalty: float
```

### night_visibility_penalty

```gdscript
var night_visibility_penalty: float
```

### score

```gdscript
var score: float
```

### surf

```gdscript
var surf: Dictionary
```

### brush

```gdscript
var brush: Variant
```

### conceal

```gdscript
var conceal: float
```

### weather_severity

```gdscript
var weather_severity: float
```

### hour

```gdscript
var hour: int
```

### night_mult

```gdscript
var night_mult: float
```
